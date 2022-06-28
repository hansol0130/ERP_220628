USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_EVT_ROULETTE_SMS_LIST
■ DESCRIPTION				: 룰렛이벤트 SMS 전송 리스트
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-06-03		정지용
   2014-09-02		정지용			호텔 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_ROULETTE_SMS_LIST]
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH LIST AS
	(
		SELECT
			A.NEW_DATE,
			B.CUS_ID,
			B.CUS_NAME,
			B.NOR_TEL1,
			B.NOR_TEL2,
			B.NOR_TEL3,
			B.EMAIL,
			A.RES_CODE,
			C.PRO_CODE,
			E.ARR_DATE
		FROM EVT_ROULETTE A WITH(NOLOCK)
		INNER JOIN CUS_MEMBER B WITH(NOLOCK) ON A.CUS_CODE = B.CUS_NO
		INNER JOIN RES_MASTER_damo C WITH(NOLOCK) ON A.RES_CODE = C.RES_CODE
		INNER JOIN RES_CUSTOMER_damo AS D WITH(NOLOCK) ON C.RES_CODE = D.RES_CODE AND A.CUS_CODE = D.CUS_NO AND D.RES_STATE IN (0) 	
		INNER JOIN PKG_DETAIL E WITH(NOLOCK) ON C.PRO_CODE = E.PRO_CODE	
		GROUP BY C.RES_CODE, D.SEQ_NO, A.NEW_DATE,B.CUS_ID,B.CUS_NAME,B.NOR_TEL1,B.NOR_TEL2,B.NOR_TEL3,B.EMAIL,A.RES_CODE,C.PRO_CODE,E.ARR_DATE
		HAVING CONVERT(VARCHAR, GETDATE(), 112) = CONVERT(VARCHAR, DATEADD(DAY, 1, E.ARR_DATE), 112)
		--HAVING CONVERT(VARCHAR, GETDATE(), 112) > CONVERT(VARCHAR, E.ARR_DATE, 112)

		UNION ALL

		SELECT
			A.NEW_DATE,
			B.CUS_ID,
			B.CUS_NAME,
			B.NOR_TEL1,
			B.NOR_TEL2,
			B.NOR_TEL3,
			B.EMAIL,
			A.RES_CODE,
			C.PRO_CODE,
			C.ARR_DATE
		FROM EVT_ROULETTE A WITH(NOLOCK)
		INNER JOIN CUS_MEMBER B WITH(NOLOCK) ON A.CUS_CODE = B.CUS_NO
		INNER JOIN RES_MASTER_damo C WITH(NOLOCK) ON A.RES_CODE = C.RES_CODE AND C.PRO_TYPE = 3
		GROUP BY C.RES_CODE, A.NEW_DATE,B.CUS_ID,B.CUS_NAME,B.NOR_TEL1,B.NOR_TEL2,B.NOR_TEL3,B.EMAIL,A.RES_CODE,C.PRO_CODE,C.ARR_DATE
		HAVING CONVERT(VARCHAR, GETDATE(), 112) = CONVERT(VARCHAR, DATEADD(DAY, 1, C.ARR_DATE), 112)
	)
	SELECT * FROM LIST WHERE (NOR_TEL1 IS NOT NULL OR NOR_TEL2 IS NOT NULL or NOR_TEL3 IS NOT NULL) ORDER BY ARR_DATE ASC

END 




GO
