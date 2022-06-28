USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_HOLIDAY_UPDATE
■ DESCRIPTION				: 휴일 수정
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 	
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2015-01-19		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PUB_HOLIDAY_UPDATE]
	@BEFORE_HOLIDAY VARCHAR(10),
	@HOLIDAY VARCHAR(10),
	@HOLIDAY_NAME VARCHAR(20),
	@IS_HOLIDAY CHAR(1),
	@EDT_CODE CHAR(7)
AS 
BEGIN
	SET NOCOUNT OFF;

	IF NOT EXISTS( SELECT 1 FROM PUB_HOLIDAY WHERE HOLIDAY = @BEFORE_HOLIDAY)
	BEGIN
		SELECT 0;
		RETURN;
	END

	UPDATE PUB_HOLIDAY SET 
		HOLIDAY = @HOLIDAY, 
		HOLIDAY_NAME = @HOLIDAY_NAME, 
		IS_HOLIDAY = @IS_HOLIDAY, 
		EDT_CODE = @EDT_CODE, 
		EDT_DATE = GETDATE()
	WHERE 
		HOLIDAY = @BEFORE_HOLIDAY

	IF @@ROWCOUNT > 0
	BEGIN
		SELECT 1;
		RETURN;
	END
END

GO
