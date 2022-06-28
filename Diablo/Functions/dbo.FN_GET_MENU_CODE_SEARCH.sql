USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: FN_GET_MENU_CODE_SEARCH
■ Description				: 마스터코드로 메뉴코드값 받아오기
■ Input Parameter			:                  
		@MASTER_CODE		: 마스터코드		
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.FN_GET_MENU_CODE_SEARCH('app9651')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2012-08-29		이동호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[FN_GET_MENU_CODE_SEARCH]
(
	@MASTER_CODE		VARCHAR(10)
)
RETURNS VARCHAR(100)
AS
BEGIN
	
	DECLARE @RETVALUE VARCHAR(10)
	SET @RETVALUE = ''
	
	DECLARE @GROUP_CODE VARCHAR(10)

	SELECT TOP 1 @GROUP_CODE = GROUP_CODE FROM PKG_GROUP WHERE MASTER_CODE = @MASTER_CODE ORDER BY NEW_DATE DESC

	SELECT TOP 1 @RETVALUE = MENU_CODE FROM MNU_MASTER_REL  WHERE GROUP_CODE = @GROUP_CODE AND SITE_CODE ='VGT' ORDER BY LEN(PARENT_CODE) DESC 
		
	RETURN @RETVALUE 
END
GO
