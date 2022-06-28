USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_MENU_CODE
■ Description				: MNU_MNG_ITEM 테이블을 확인하여 값이 있는 메뉴코드를 리턴한다
■ Input Parameter			:                  
	@SITE_CODE				: 사이트코드 (참좋은여행 : VGT)
	@MENU_CODE				: 체크할 메뉴코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_COM_MENU_CODE('VGT', '10101')
	SELECT DBO.XN_COM_MENU_CODE('VGT', '1010215684848')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-03-19		김성호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_COM_MENU_CODE]
(
	@SITE_CODE VARCHAR(3),
	@MENU_CODE VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN

	IF LEN(@MENU_CODE) > 3
	BEGIN

		IF NOT EXISTS(SELECT 1 FROM MNU_MNG_ITEM WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE)
		BEGIN
			SELECT @MENU_CODE = SUBSTRING(@MENU_CODE, 1, (LEN(@MENU_CODE) - 2))
			SET @MENU_CODE = DBO.XN_COM_MENU_CODE(@SITE_CODE, @MENU_CODE)
		END
	END

	RETURN @MENU_CODE

END

GO
