USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_DELETE
■ DESCRIPTION				: 메뉴 삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 하위 메뉴 모두 USE_YN = 'N'으로 업데이트
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-03		김성호			최초생성
   2015-05-18		정지용			잘못된 데이타는 삭제처리
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PUB_MENU_DELETE]
(
	@SITE_CODE		VARCHAR(3),
	@MENU_CODE		VARCHAR(20),
	@EDT_CODE		CHAR(7)
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF EXISTS(SELECT 1 FROM MNU_MASTER WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE AND MENU_NAME = '새 메뉴')
	BEGIN
		IF EXISTS(SELECT 1 FROM MNU_MASTER WHERE SITE_CODE = @SITE_CODE AND PARENT_CODE = @MENU_CODE)
		BEGIN
			-- 하위에 노드가 있다면 부모만 삭제 안되도록 일단 처리 ( 새 메뉴라는 걸 만들고 하위구성중 삭제 할 경우 생각 )
			RETURN;
		END
		DELETE FROM MNU_MASTER WHERE SITE_CODE = @SITE_CODE AND MENU_CODE = @MENU_CODE
		RETURN;
	END

	UPDATE MNU_MASTER SET USE_YN = 'N', EDT_CODE = @EDT_CODE, EDT_DATE = GETDATE() 
	WHERE SITE_CODE = @SITE_CODE AND MENU_CODE LIKE @MENU_CODE + '%';

END


GO
