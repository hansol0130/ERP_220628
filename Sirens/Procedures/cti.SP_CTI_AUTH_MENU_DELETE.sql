USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_MENU_DELETE
■ DESCRIPTION				: 사용자 메뉴권한 삭제
■ INPUT PARAMETER			:  
@AUTH_ID					: 권한ID 
@MENU_ID(4)					: 메뉴ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec  SP_CTI_AUTH_MENU_DELETE '999', 'A001'; 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
   ================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_MENU_DELETE]
--DECLARE
	@AUTH_ID	VARCHAR(20),
	@MENU_ID		VARCHAR(20)

--SET @AUTH_ID = '999'
--SET @MENU_ID = ''

AS

BEGIN

DELETE FROM sirens.cti.CTI_AUTH_MENU 
WHERE AUTH_ID = @AUTH_ID
AND  MENU_ID = @MENU_ID

	--SELECT @AUTH_ID as AUTH_ID, @MENU_ID as MENU_ID
END
GO
