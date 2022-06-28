USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PUB_HOLIDAY_INSERT
■ DESCRIPTION				: 휴일 입력
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
CREATE PROC [dbo].[SP_PUB_HOLIDAY_INSERT]
	@HOLIDAY VARCHAR(10),
	@HOLIDAY_NAME VARCHAR(20),
	@NEW_CODE CHAR(7)
AS 
BEGIN
	SET NOCOUNT OFF;

	IF EXISTS( SELECT 1 FROM PUB_HOLIDAY WHERE HOLIDAY = @HOLIDAY)
	BEGIN
		SELECT 0;
		RETURN;
	END

	INSERT INTO PUB_HOLIDAY ( HOLIDAY, HOLIDAY_NAME, IS_HOLIDAY, NEW_CODE, NEW_DATE )
	VALUES (@HOLIDAY, @HOLIDAY_NAME, 'Y', @NEW_CODE, GETDATE())

	IF @@ROWCOUNT > 0
	BEGIN
		SELECT 1;
	END
END

GO
