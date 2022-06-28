USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_DISPLAY_SCREEN_MANAGE_UPDATE
■ DESCRIPTION				: ERP 전광판 관리 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-09-16		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_DISPLAY_SCREEN_MANAGE_UPDATE]
	  @SEQ_NO INT
	, @TITLE VARCHAR(100)
	, @CONTENT VARCHAR(400)
	, @USE_YN CHAR(1)
	, @ORDER_NO INT
	, @EDT_CODE CHAR(7)
AS 
BEGIN
	SET NOCOUNT OFF;

	IF EXISTS ( SELECT 1 FROM PUB_DISPLAY_SCREEN WITH(NOLOCK) WHERE ORDER_NO = @ORDER_NO )
	BEGIN
		UPDATE PUB_DISPLAY_SCREEN SET
			ORDER_NO = (SELECT ORDER_NO FROM PUB_DISPLAY_SCREEN WHERE SEQ_NO = @SEQ_NO )
		WHERE ORDER_NO = @ORDER_NO
	END

	UPDATE PUB_DISPLAY_SCREEN SET 
		TITLE = @TITLE,
		CONTENT = @CONTENT,
		USE_YN = @USE_YN,
		ORDER_NO = @ORDER_NO,
		EDT_CODE = @EDT_CODE,
		EDT_DATE = GETDATE()
	WHERE SEQ_NO = @SEQ_NO

	SELECT @@ROWCOUNT;

END
GO
