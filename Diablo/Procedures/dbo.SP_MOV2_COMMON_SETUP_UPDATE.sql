USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_MOV2_COMMON_SETUP_UPDATE
■ DESCRIPTION				: 수정_푸시큐비사용여부
■ INPUT PARAMETER			: 
	@CUS_NO					: 고객 번호
	@PUSH_YN				: PUSH Y: 사용, N: 사용안함
	@CUVE_YN				: CUVE Y: 사용, N: 사용안함
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	SP_MOV2_COMMON_SETUP_UPDATE 8505125, 'Y', 'N', 1
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------

================================================================================================================*/ 
CREATE PROC [dbo].[SP_MOV2_COMMON_SETUP_UPDATE]
	@CUS_NO			INT,
	@PUSH_YN		CHAR(1),
	@CUVE_YN		CHAR(1),
	@FONT_SIZE		INT
AS 
BEGIN

	IF EXISTS(SELECT * FROM CUS_MEMBER_OPTION WHERE CUS_NO = @CUS_NO)
		BEGIN
			UPDATE CUS_MEMBER_OPTION
				SET PUSH_YN = @PUSH_YN,
					CUVE_YN = @CUVE_YN,
					FONT_SIZE = @FONT_SIZE,
					NEW_DATE = getDate()
				WHERE CUS_NO = @CUS_NO
		END
	ELSE
		BEGIN
			INSERT INTO CUS_MEMBER_OPTION (CUS_NO, PUSH_YN, CUVE_YN, FONT_SIZE, NEW_CODE, NEW_DATE) 
				VALUES (@CUS_NO, @PUSH_YN, @CUVE_YN, @FONT_SIZE, '9999999', GETDATE() )

		END

END 


GO
