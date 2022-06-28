USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_MENU_SELECT
■ DESCRIPTION				: 그룹권한별 메뉴 조회
■ INPUT PARAMETER			: 
	@AUTH_ID				: 권한ID 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_MENU_SELECT '999';

	AUTH_ID MENU_ID MENU_NAME
------- ------- --------------------------------------------------
999     C001    고객검색
999     C002    전화약속

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_MENU_SELECT]
--DECLARE
	@AUTH_ID	VARCHAR(20)

--SET @AUTH_ID = '999'

AS

SELECT 
  A.AUTH_ID,
  A.MENU_ID,
  B.MENU_NAME
FROM sirens.cti.CTI_AUTH_MENU A WITH(NOLOCK)
LEFT OUTER JOIN sirens.cti.CTI_MENU B
ON A.MENU_ID = B.MENU_ID
WHERE A.AUTH_ID = @AUTH_ID
GO
