USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_RES_RECOMMEND_CODE_SAVE
■ DESCRIPTION				: 추천인/추천 코드 저장 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-03-15		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_RES_RECOMMEND_CODE_SAVE]
	@RES_CODE	RES_CODE,
	@CODE VARCHAR(20)
AS 
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
	IF EXISTS (
	       SELECT 1
	       FROM   dbo.RES_RECOMMEND_CODE
	       WHERE RES_CODE = @RES_CODE
	   )
	BEGIN
		UPDATE dbo.RES_RECOMMEND_CODE
		SET    RES_CODE = @RES_CODE
		      ,CODE = @CODE
		      ,EDT_DATE = GETDATE()
		WHERE  RES_CODE = @RES_CODE
	END
	ELSE
	BEGIN
		
		INSERT INTO dbo.RES_RECOMMEND_CODE
		(
			RES_CODE,
			CODE,
			NEW_DATE
		)
		VALUES
		(
			@RES_CODE,
			@CODE,
			GETDATE()
		)
		
	END 
	

END 
GO
