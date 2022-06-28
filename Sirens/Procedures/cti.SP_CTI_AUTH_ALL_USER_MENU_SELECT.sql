USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_ALL_USER_MENU_SELECT
■ DESCRIPTION				: 사용자 전체  메뉴 조회
■ INPUT PARAMETER			: 
	@AUTH_ID					: 그룹코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_ALL_USER_MENU_SELECT '999'

	MENU_ID MENU_NAME
------- --------------------------------------------------
SA02    메뉴관리
SA03    그룹권한관리


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_ALL_USER_MENU_SELECT]
--DECLARE
	@AUTH_ID	VARCHAR(20)

--SET @AUTH_ID = ''

AS
BEGIN
  SELECT 
    MENU_ID, 
    MENU_NAME
  FROM sirens.cti.CTI_MENU
  WHERE MENU_LEVEL = '20'
  EXCEPT
  SELECT 
    MENU_ID, 
    MENU_NAME
FROM Sirens.cti.CTI_AUTH
WHERE AUTH_ID = @AUTH_ID

END
GO
