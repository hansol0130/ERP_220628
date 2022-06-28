USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_GET_NAVI
■ Description				: MNU_MASTER_REL 의 최상위 메뉴코드를 리턴한다.
■ Input Parameter			:                  
	@SITE_CODE				: 사이트코드 (참좋은여행 : VGT)
	@MENU_CODE				: 체크할 메뉴코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_COM_GET_NAVI('VGT', '10101')
	SELECT DBO.XN_COM_GET_NAVI('VGT', '10101030101')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-04-01		김성호			최초생성
	2013-05-28		김성호			메뉴코드가 존재하지 않아도 따옴표로 감싸주게 수정
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_COM_GET_NAVI]
(
	@SITE_CODE VARCHAR(3),
	@MENU_CODE VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
	
	IF EXISTS(SELECT 1 FROM MNU_MASTER_REL WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = SUBSTRING(@MENU_CODE, CHARINDEX('|', @MENU_CODE) + 1, 100) AND PARENT_CODE IS NOT NULL)
	BEGIN
		SELECT @MENU_CODE = REPLACE(@MENU_CODE, '|', ',''') + '''|' + PARENT_CODE
		FROM MNU_MASTER_REL
		WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = SUBSTRING(@MENU_CODE, CHARINDEX('|', @MENU_CODE) + 1, 100)

		SET @MENU_CODE = DBO.XN_COM_GET_NAVI(@SITE_CODE, @MENU_CODE)
	END
	ELSE IF EXISTS(SELECT 1 FROM MNU_MASTER_REL WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = SUBSTRING(@MENU_CODE, CHARINDEX('|', @MENU_CODE) + 1, 100) AND PARENT_CODE IS NULL)
	BEGIN
		SET @MENU_CODE = '''' + REPLACE(@MENU_CODE, '|', ',''') + ''''
	END
	ELSE
	BEGIN
		SET @MENU_CODE = '''' + @MENU_CODE + ''''
	END

	RETURN @MENU_CODE

END
GO
