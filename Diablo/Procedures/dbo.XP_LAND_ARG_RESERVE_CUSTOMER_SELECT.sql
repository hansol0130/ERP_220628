USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_LAND_ARG_RESERVE_CUSTOMER_SELECT
■ DESCRIPTION				: 예약코드와 예약자 순번으로 수배상태 조회
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
exec XP_LAND_ARG_RESERVE_CUSTOMER_SELECT @RES_CODE=N'RP1404291884',@CUS_SEQ=N'1,4'	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-05-13		정지용
   2014-11-05		정지용			수배취소 -> 수배취소, 수배확정취소, 인보이스취소, 인보이스확정취소 추가
   2014-11-25		정지용			인보인스확정 / 정산 / 지급일경우 BREAK, 일반수배상태 취소OK, 수배없을 땐 PASS
================================================================================================================*/ 
CREATE PROC [dbo].[XP_LAND_ARG_RESERVE_CUSTOMER_SELECT]
 	@RES_CODE CHAR(12),
	@CUS_SEQ VARCHAR(4000)
AS 
BEGIN
	-- 전체0, 수배요청1, 수배확정2, 수배취소3, 수배확정취소4, 인보이스발행5, 인보이스확정6, 인보이스취소7, 인보이스확정취소8, 정산결재9, 정산지급10
	--SELECT COUNT(1)
	SELECT CASE WHEN MAX(B.ARG_STATUS) IS NULL THEN 'PASS' ELSE CASE MAX(B.ARG_STATUS) WHEN 6 THEN 'BREAK' WHEN 9 THEN 'BREAK' WHEN 10 THEN 'BREAK' ELSE 'CANCEL' END END AS ARG_STATUS
	FROM ARG_CUSTOMER A WITH(NOLOCK)
		INNER JOIN ARG_DETAIL B WITH(NOLOCK)
			ON A.ARG_CODE = B.ARG_CODE 
		INNER JOIN ARG_CONNECT C WITH(NOLOCK)
			ON A.ARG_CODE = C.ARG_CODE 
			AND A.CUS_SEQ_NO = C.CUS_SEQ_NO
			AND B.GRP_SEQ_NO = C.GRP_SEQ_NO 
			AND C.GRP_SEQ_NO = ( 
				SELECT MAX(AA.GRP_SEQ_NO) FROM ARG_CONNECT AA WITH(NOLOCK)
					INNER JOIN ARG_DETAIL BB  WITH(NOLOCK)	ON AA.ARG_CODE = BB.ARG_CODE AND AA.GRP_SEQ_NO = BB.GRP_SEQ_NO 
				WHERE AA.ARG_CODE = C.ARG_CODE  AND AA.CUS_SEQ_NO = C.CUS_SEQ_NO AND BB.ARG_STATUS NOT IN ( 3, 4, 7, 8 )  )
		WHERE A.RES_CODE = @RES_CODE 
			AND 
				( (ISNULL(@CUS_SEQ, '') = '' AND CONVERT(varchar, SEQ_NO) IN ( SELECT SEQ_NO FROM RES_CUSTOMER WHERE RES_CODE = @RES_CODE)) 
				OR
				  (ISNULL(@CUS_SEQ, '') <> '' AND CONVERT(varchar, SEQ_NO) IN ( SELECT DATA FROM DBO.FN_SPLIT(@CUS_SEQ, ','))) )

END 
GO
