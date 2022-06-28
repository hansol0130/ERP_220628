USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_LAND_PAY_LIST_SELECT
■ DESCRIPTION				: 랜드사 지상비 리스트 검색
■ INPUT PARAMETER			: 
	@PRO_CODE	VARCHAR(20) : 행사코드
	@AGT_CODE	VARCHAR(10) : 거래처코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-09-01		이규식			최초생성    
================================================================================================================*/ 

 CREATE PROCEDURE [dbo].[XP_LAND_PAY_LIST_SELECT] 
 ( 
    @PRO_CODE	VARCHAR(20),
	@AGT_CODE	VARCHAR(10)
) 
AS 
BEGIN 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


SELECT 
A.*, B.SET_STATE,
(SELECT KOR_NAME FROM AGT_MASTER WITH(NOLOCK) WHERE AGT_CODE = A.AGT_CODE) AS AGT_NAME,
(SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = A.NEW_CODE) AS NEW_NAME,
(SELECT KOR_NAME FROM EMP_MASTER WITH(NOLOCK) WHERE EMP_CODE = A.EDT_CODE) AS EDT_NAME
FROM SET_LAND_AGENT A WITH(NOLOCK)
INNER JOIN SET_MASTER B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE
WHERE A.PRO_CODE = @PRO_CODE AND A.AGT_CODE = @AGT_CODE


END 


GO
