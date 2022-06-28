USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_CTI_AUTH_EMP_DELETE
■ DESCRIPTION				: 사용자 메뉴권한 삭제
■ INPUT PARAMETER			:  
	@FROM_EMP_CODE	VARCHAR(20), : 직원코드
	@MENU_ID		VARCHAR(20)	 : 메뉴ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_AUTH_EMP_DELETE '2012019', 'A001';

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-11-11		홍영택			최초생성
   2015-02-05		박노민			설명추가
   ================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_AUTH_EMP_DELETE]
--DECLARE
	@FROM_EMP_CODE	VARCHAR(20),
	@MENU_ID		VARCHAR(20)

--SET @AUTH_ID = '2012111'
--SET @MENU_ID = ''

AS

BEGIN

DELETE FROM sirens.cti.CTI_AUTH 
WHERE AUTH_ID = @FROM_EMP_CODE
AND  MENU_ID = @MENU_ID

	--SELECT @AUTH_ID as AUTH_ID, @MENU_ID as MENU_ID
END
GO
