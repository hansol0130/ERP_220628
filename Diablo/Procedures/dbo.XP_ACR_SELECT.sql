USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ACR_SELECT
■ DESCRIPTION				: 경위서 상세
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_ACR_SELECT 1
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-19		김완기			최초생성
   2013-06-19		정연주			행사명, 랜드사명 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ACR_SELECT]
 	@ACR_SEQ_NO int
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	


	SELECT 
		A.*,
		(SELECT PRO_NAME FROM dbo.PKG_DETAIL WHERE PRO_CODE = A.PRO_CODE) AS PRO_NAME,
		(SELECT KOR_NAME FROM PUB_REGION WHERE REGION_CODE = A.REGION_CODE) AS REGION_NAME,
		DBO.XN_COM_GET_EMP_NAME(A.GUIDE_CODE) AS GUIDE_NAME,
		DBO.XN_COM_GET_EMP_NAME(A.CFM_CODE) AS CFM_NAME,
		DBO.XN_COM_GET_TEAM_NAME(A.CFM_CODE) AS CFM_TEAM_NAME,
		DBO.XN_COM_GET_EMP_NAME(A.NEW_CODE) AS NEW_NAME,
		DBO.XN_COM_GET_TEAM_NAME(A.NEW_CODE) AS NEW_TEAM_NAME,
		C.AGT_NAME,
		C.ADDRESS1,
		C.ADDRESS2,
		C.NOR_TEL1,
		C.NOR_TEL2,
		C.NOR_TEL3,
		C.FAX_TEL1,
		C.FAX_TEL2,
		C.FAX_TEL3,
		C.AGT_CONDITION,
		C.AGT_ITEM,
		C.AGT_REGISTER,
		C.CEO_NAME
	FROM ACR_MASTER A WITH(NOLOCK)
	LEFT OUTER JOIN AGT_MASTER C WITH(NOLOCK) ON A.AGT_CODE = C.AGT_CODE
	WHERE A.ACR_SEQ_NO = @ACR_SEQ_NO


END
GO
