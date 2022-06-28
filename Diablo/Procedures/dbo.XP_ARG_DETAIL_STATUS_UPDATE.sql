USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*================================================================================================================
■ USP_NAME					: XP_ARG_DETAIL_STATUS_UPDATE
■ DESCRIPTION				: 수배현황상세 상태 업데이트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	DECLARE @ARG_SEQ_NO INT ,
		    @GRP_SEQ_NO INT,
	        @ARG_DETAIL_STATUS INT

	SET @ARG_CODE = A140325-0006
	SET @GRP_SEQ_NO = 1
	SET @ARG_STATUS = 1

	EXEC DBO.XP_ARG_DETAIL_STATUS_UPDATE @ARG_CODE, @GRP_SEQ_NO, @ARG_STATUS
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-28		김완기			최초생성
   2014-03-25		이동호			--
   2014-03-27		김성호			ARG_CUSTOMER 테이블 상태값도 동시 변경
   2014-04-03		이동호			ARG_DETAIL, ARG_DETAIL 테이블 각각 상태값 변경
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_DETAIL_STATUS_UPDATE]
	@ARG_CODE VARCHAR(12) ,
	@GRP_SEQ_NO INT,
	@ARG_DETAIL_STATUS INT,
	@ARG_CUSTOMER_STATUS INT,
	@NEW_CODE VARCHAR(7)
AS 
BEGIN
	UPDATE ARG_DETAIL
	SET ARG_STATUS = @ARG_DETAIL_STATUS, EDT_CODE = @NEW_CODE, EDT_DATE = getdate()
	WHERE ARG_CODE =  @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO

	UPDATE A SET A.ARG_STATUS = @ARG_CUSTOMER_STATUS, A.EDT_CODE = @NEW_CODE, A.EDT_DATE = GETDATE()
	FROM ARG_CUSTOMER A
	INNER JOIN ARG_CONNECT B ON A.ARG_CODE = B.ARG_CODE AND A.CUS_SEQ_NO = B.CUS_SEQ_NO
	WHERE B.ARG_CODE = @ARG_CODE AND B.GRP_SEQ_NO = @GRP_SEQ_NO

	-- 확정 취소일 때 지상비 삭제
	IF @ARG_DETAIL_STATUS = 8 AND @ARG_CUSTOMER_STATUS = 5
	BEGIN
		DELETE FROM A
		FROM SET_LAND_AGENT A
		INNER JOIN (
			SELECT A.PRO_CODE, B.LAND_SEQ_NO
			FROM ARG_MASTER A
			INNER JOIN ARG_INVOICE B ON A.ARG_CODE = B.ARG_CODE
			WHERE A.ARG_CODE = @ARG_CODE AND B.GRP_SEQ_NO = @GRP_SEQ_NO
		) B ON A.PRO_CODE = B.PRO_CODE AND A.LAND_SEQ_NO = B.LAND_SEQ_NO
		WHERE A.DOC_YN = 'N'

		UPDATE ARG_INVOICE SET LAND_SEQ_NO = 0 WHERE ARG_CODE = @ARG_CODE AND GRP_SEQ_NO = @GRP_SEQ_NO
	END
END 


GO
