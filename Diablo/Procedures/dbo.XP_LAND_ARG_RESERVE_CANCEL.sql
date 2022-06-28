USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_LAND_ARG_RESERVE_CANCEL
■ DESCRIPTION				: 수배상태 전체 취소
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
exec XP_LAND_ARG_RESERVE_CANCEL @RES_CODE=N'RP1404291884',@CUS_SEQ=N'1,4'
exec XP_LAND_ARG_RESERVE_CANCEL '234234234234','1,4', '9999999', '예약이동'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-25		정지용
   2014-12-03		정지용			캔슬시 예약이동 텍스트 비고란에 업데이트
   2014-12-23		정지용			취소시 해당 담당자들에게 사내메일 발송
   2017-06-09		박형만			ARG_DETAIL 취소시 해당예약의 출발자 수배의 수배만 취소되도록 
================================================================================================================*/ 
CREATE PROC [dbo].[XP_LAND_ARG_RESERVE_CANCEL]
 	@RES_CODE CHAR(12),
	@CUS_SEQ varchar(4000),
	@EDT_CODE VARCHAR(7),
	@MEMO VARCHAR(40)
AS 
BEGIN


--declare @RES_CODE CHAR(12),
--	@CUS_SEQ varchar(4000),
--	@EDT_CODE VARCHAR(7),
--	@MEMO VARCHAR(40)

--set @RES_CODE = 'RP1705252498'

	-- 전체0, 수배요청1, 수배확정2, 수배취소3, 수배확정취소4, 인보이스발행5, 인보이스확정6, 인보이스취소7, 인보이스확정취소8, 정산결재9, 정산지급10

	--DECLARE @ARG_CODE VARCHAR(12)
	UPDATE A SET 
		--@ARG_CODE = A.ARG_CODE = A.ARG_CODE, 
		A.ARG_STATUS = (CASE A.ARG_STATUS WHEN 1 THEN 3 WHEN 2 THEN 3 WHEN 5 THEN 7 ELSE A.ARG_STATUS END), 
		A.EDT_CODE = @EDT_CODE, 
		A.EDT_DATE = GETDATE(),
		A.ETC_REMAKR = @MEMO + ISNULL(ETC_REMAKR, '')
	FROM ARG_CUSTOMER A 
		INNER JOIN ARG_DETAIL B
			ON A.ARG_CODE = B.ARG_CODE 
		INNER JOIN ARG_CONNECT C
			ON A.ARG_CODE = C.ARG_CODE 
			AND A.CUS_SEQ_NO = C.CUS_SEQ_NO
			AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
			AND C.GRP_SEQ_NO = ( 
				SELECT MAX(AA.GRP_SEQ_NO) FROM ARG_CONNECT AA
					INNER JOIN ARG_DETAIL BB	ON AA.ARG_CODE = BB.ARG_CODE AND AA.GRP_SEQ_NO = BB.GRP_SEQ_NO 
				WHERE AA.ARG_CODE = C.ARG_CODE  AND AA.CUS_SEQ_NO = C.CUS_SEQ_NO )
		--WHERE A.RES_CODE = @RES_CODE AND  CONVERT(varchar, SEQ_NO) IN ( SELECT DATA FROM DBO.FN_SPLIT(@CUS_SEQ, ','))
		WHERE 
			A.RES_CODE = @RES_CODE 
			AND 
				( (ISNULL(@CUS_SEQ, '') = '' AND CONVERT(varchar, SEQ_NO) IN ( SELECT SEQ_NO FROM RES_CUSTOMER WHERE RES_CODE = @RES_CODE)) 
				OR
				  (ISNULL(@CUS_SEQ, '') <> '' AND CONVERT(varchar, SEQ_NO) IN ( SELECT DATA FROM DBO.FN_SPLIT(ISNULL(@CUS_SEQ, ''), ','))) )

	-- 문서상태 취소로 변경
	UPDATE A SET A.ARG_STATUS = (CASE A.ARG_STATUS WHEN 1 THEN 3 WHEN 2 THEN 4 WHEN 5 THEN 7 ELSE ARG_STATUS END), EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE()
	--SELECT A.ARG_CODE, A.GRP_SEQ_NO ,  A.ARG_STATUS , CASE A.ARG_STATUS WHEN 1 THEN 3 WHEN 2 THEN 4 WHEN 5 THEN 7 ELSE ARG_STATUS END 
	FROM ARG_DETAIL A 
		INNER JOIN 
		(	SELECT AA.ARG_CODE, BB.GRP_SEQ_NO  FROM ARG_CUSTOMER AA 
			INNER JOIN ARG_CONNECT BB 
				ON AA.ARG_CODE = BB.ARG_CODE 
				AND AA.CUS_SEQ_NO = BB.CUS_SEQ_NO 
			WHERE RES_CODE = @RES_CODE
			GROUP BY AA.ARG_CODE, BB.GRP_SEQ_NO   -- 해당예약이 포함된 출발자의 GRP_SEQ_NO 
		) B 
		ON A.ARG_CODE  = B.ARG_CODE 
		AND A.GRP_SEQ_NO = B.GRP_SEQ_NO 

	--WHERE ARG_CODE IN (SELECT ARG_CODE FROM ARG_CUSTOMER WHERE RES_CODE = @RES_CODE GROUP BY ARG_CODE)	

	-- 수배취소 메일보내기
	/*
	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @PRO_CODE VARCHAR(20)
		DECLARE @IDX INT
		SELECT TOP 1 @PRO_CODE = PRO_CODE FROM RES_MASTER WITH(NOLOCK) WHERE RES_CODE = @RES_CODE
		IF @PRO_CODE <> ''
		BEGIN
			INSERT INTO PRI_NOTE(SUBJECT, CONTENTS, NEW_CODE)
			VALUES('[' + @PRO_CODE +  '] 수배가 취소되었습니다.', '[' + @PRO_CODE +  '] 수배가 취소되었습니다. 확인바랍니다.', '9999999');

			SET @IDX = @@IDENTITY
			IF @IDX > 0
			BEGIN
				INSERT INTO PRI_NOTE_RECEIPT
				(NOTE_SEQ_NO, RCV_SEQ_NO, EMP_CODE, RCV_TYPE, TEAM_NAME,SEND_CAT_SEQ_NO)
				SELECT 
					@IDX, 1, C.MEM_CODE, 1, B.AGT_NAME , 0
				FROM ARG_MASTER A WITH(NOLOCK)
				INNER JOIN AGT_MASTER B ON A.AGT_CODE = B.AGT_CODE
				INNER JOIN AGT_MEMBER C ON B.AGT_CODE = C.AGT_CODE AND WORK_TYPE = 1 -- 현재 재직중인 사람
					WHERE A.PRO_CODE = @PRO_CODE
						GROUP BY C.MEM_CODE, B.AGT_NAME					
			END
		END
	END
	*/
END

GO
