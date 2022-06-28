USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_SENDING_SELECT
■ DESCRIPTION				: 샌딩 정보
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SP_PKG_SENDING_SELECT '6'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
    2017-04-17		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_SENDING_SELECT]
	@SEQ_NO INT
AS 
BEGIN
	SELECT
		A.SEQ_NO,
		A.PRO_CODE,
		A.PRO_NAME,
		A.DEP_DATE,
		A.DEP_TIME,
		A.TRANS_NAME,
		A.MEET_CNT,
		A.CONTRACT_CNT,
		A.RECEIPT_CNT,
		A.MEET_COUNTER,
		A.MEET_DATE,
		A.MEET_TIME,		
		A.REMARK,
		A.MANAGER_CODE,
		(SELECT KOR_NAME FROM EMP_MASTER EM WITH(NOLOCK) WHERE EM.EMP_CODE = A.MANAGER_CODE) AS MANAGER_NAME,
		A.INNER_NUMBER,
		A.EMR_TEL_NUMBER,
		A.TC_YN,
		B.KOR_NAME AS EMP_NAME,
		C.TEAM_NAME AS TEAM_NAME,
		CASE WHEN A.EDT_CODE IS NULL THEN A.NEW_DATE ELSE A.EDT_DATE END AS NEW_DATE,
		A.SEND_KEY
	FROM PKG_SENDING A WITH(NOLOCK) 
	LEFT JOIN EMP_MASTER B WITH(NOLOCK) 
		ON (A.EDT_CODE IS NULL AND A.NEW_CODE = B.EMP_CODE) OR (A.EDT_CODE IS NOT NULL AND A.EDT_CODE = B.EMP_CODE)
	LEFT JOIN EMP_TEAM C WITH(NOLOCK) 
		ON B.TEAM_CODE = C.TEAM_CODE
	WHERE A.SEQ_NO = @SEQ_NO;
END


GO
