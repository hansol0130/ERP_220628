USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_COM_GET_TOP_MENU_CODE
■ Description				: MNU_MASTER의 최상위 메뉴코드를 리턴한다.
■ Input Parameter			:                  
	@SITE_CODE				: 사이트코드 (참좋은여행 : VGT)
	@MENU_CODE				: 체크할 메뉴코드
	@REAL_YN				: 실서버 유무
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 
	SELECT DBO.XN_COM_GET_TOP_MENU_CODE('VGT', '10101', 'Y')
	SELECT DBO.XN_COM_GET_TOP_MENU_CODE('VGT', '101010101', 'N')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2013-04-01		김성호			최초생성
-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[XN_COM_GET_TOP_MENU_CODE]
(
	@SITE_CODE VARCHAR(3),
	@MENU_CODE VARCHAR(20),
	@REAL_YN	VARCHAR(1)
)
RETURNS VARCHAR(20)
AS
BEGIN

	IF EXISTS(
		SELECT 1 FROM MNU_MASTER WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE AND PARENT_CODE IS NOT NULL AND @REAL_YN = 'N'
		UNION ALL
		SELECT 1 FROM MNU_MASTER_REL WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE AND PARENT_CODE IS NOT NULL AND @REAL_YN = 'Y'
	)
	BEGIN
		SELECT @MENU_CODE = A.PARENT_CODE FROM (
			SELECT * FROM MNU_MASTER WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE AND PARENT_CODE IS NOT NULL AND @REAL_YN = 'N'
			UNION ALL
			SELECT * FROM MNU_MASTER_REL WITH(NOLOCK) WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE AND PARENT_CODE IS NOT NULL AND @REAL_YN = 'Y'
		) A

		SET @MENU_CODE = DBO.XN_COM_GET_TOP_MENU_CODE(@SITE_CODE, @MENU_CODE, @REAL_YN)
	END

	RETURN @MENU_CODE

END


GO
