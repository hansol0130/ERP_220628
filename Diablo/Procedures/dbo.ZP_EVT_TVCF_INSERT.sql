USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================    
■ USP_Name			: [dbo].[ZP_EVT_TVCF_INSERT]      
■ Description		: TV CF 프로모션
■ Input Parameter   :                      
■ Output Parameter	:                      
■ Output Value		:                     
■ Exec				: 
------------------------------------------------------------------------------------------------------------------    
■ Change History
------------------------------------------------------------------------------------------------------------------    
	Date			Author		Description
------------------------------------------------------------------------------------------------------------------    
	2021-11-01		오준혁		최초생성
================================================================================================================*/   
CREATE PROCEDURE [dbo].[ZP_EVT_TVCF_INSERT]
	@CUS_NO    INT
AS
BEGIN
	
	SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @Status      VARCHAR(10) = ''
	       ,@Message     VARCHAR(100) = ''
	
	IF EXISTS (SELECT 1 FROM onetime.EVT_TVCF WHERE CUS_NO = @CUS_NO)
	BEGIN
		
		SET @Status = 'ERROR'
		SET @Message = '이미 신청하셨습니다.'
		
	END
	ELSE
	BEGIN
		
		INSERT INTO onetime.EVT_TVCF
		  (
		    CUS_NO
		   ,NEW_DATE
		  )
		VALUES
		  (
		    @CUS_NO
		   ,GETDATE()
		  )
		
		SET @Status = 'OK'
		SET @Message = '성공'
		
	END

	SELECT @Status AS 'Status'
	      ,@Message AS 'Message'
		
END	
GO
