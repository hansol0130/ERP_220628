USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_MANAGER_BY_AGENT
■ DESCRIPTION				: 거래처별 담당자 리스트 조회
■ INPUT PARAMETER			: 
	
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_COM_MANAGER_BY_AGENT '92756'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-27	    이유라			최초생성    
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_MANAGER_BY_AGENT]
(
	@AGT_CODE	varchar(20)  --
)
AS 
BEGIN

	SELECT A.MANAGER_TYPE,
		B.EMP_CODE, B.KOR_NAME, INNER_NUMBER1, INNER_NUMBER2, INNER_NUMBER3, 
		FAX_NUMBER1, FAX_NUMBER2, FAX_NUMBER3, EMAIL, GREETING , 
		B.TEAM_CODE , 
		(SELECT TEAM_NAME FROM EMP_TEAM WITH(NOLOCK) WHERE TEAM_CODE = B.TEAM_CODE) AS [TEAM_NAME],
	    (SELECT PUB_VALUE FROM COD_PUBLIC WITH(NOLOCK) WHERE PUB_TYPE='EMP.POSTYPE' AND PUB_CODE=B.POS_TYPE) AS [POS_NAME]
	FROM COM_MANAGER A
	LEFT JOIN EMP_MASTER B ON A.EMP_CODE = B.EMP_CODE
	WHERE A.AGT_CODE = @AGT_CODE

END 

GO
