USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EVT_SSG_COUPON_SEND_LIST_SELECT
■ DESCRIPTION				: 신세계면세점 상품권 정기 문자 발송 대상자 검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_EVT_SSG_COUPON_SEND_LIST_SELECT

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-09-08		김성호			최초생성
   2016-10-04		김성호			기간 10.09에서 12.31까지 연장
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_SSG_COUPON_SEND_LIST_SELECT]
AS 
BEGIN

	WITH LIST AS
	(
		SELECT B.RES_CODE, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3, MIN(B.SEQ_NO) AS [SEQ_NO]
		FROM RES_MASTER_damo A WITH(NOLOCK)
		INNER JOIN RES_CUSTOMER_damo B WITH(NOLOCK) ON A.RES_CODE = B.RES_CODE
		INNER JOIN PKG_MASTER C WITH(NOLOCK) ON A.MASTER_CODE = C.MASTER_CODE
		WHERE 
			--A.RES_CODE IN ('RP1606298825') AND
			A.DEP_DATE >= '2016-09-10' AND A.DEP_DATE < '2017-01-01' AND A.DEP_DATE > GETDATE()
			AND A.RES_STATE < 7 AND B.RES_STATE = 0
			AND B.NOR_TEL1 LIKE '01[0,1,6,7,8,9]' AND LEN(B.NOR_TEL2) >= 3 AND LEN(B.NOR_TEL3) = 4
			AND C.BRANCH_CODE = 0 AND C.SIGN_CODE <> 'K'
			AND (B.BIRTH_DATE IS NULL OR DBO.FN_CUS_GET_AGE(B.BIRTH_DATE, A.DEP_DATE) >= 18)
		GROUP BY B.RES_CODE, B.NOR_TEL1, B.NOR_TEL2, B.NOR_TEL3
	)
	SELECT A.*, B.CUS_NAME
	FROM LIST A
	INNER JOIN RES_CUSTOMER_damo B ON A.RES_CODE = B.RES_CODE AND A.SEQ_NO = B.SEQ_NO
	LEFT JOIN EVT_SSG_DUTYFREE C WITH(NOLOCK) ON A.RES_CODE = C.RES_CODE AND A.NOR_TEL1 = C.NOR_TEL1 AND A.NOR_TEL2 = C.NOR_TEL2 AND A.NOR_TEL3 = C.NOR_TEL3
	WHERE C.RES_CODE IS NULL AND LEN(B.CUS_NAME) <= 3

END


GO
