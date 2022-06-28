USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================    
■ USP_NAME     : [ZP_CUS_POINT_HISTORY_DELETE]    
■ DESCRIPTION    : 포인트 사용 취소    
■ INPUT PARAMETER   :     
■ OUTPUT PARAMETER   :     
■ EXEC      :     
■ MEMO      :     
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
   DATE    AUTHOR   DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
   2020-01-08  오준혁   포인트 사용 취소
================================================================================================================*/     
CREATE PROCEDURE [interface].[ZP_CUS_POINT_HISTORY_DELETE]
	 @CUS_NO   INT
	,@POINT_NO INT
	,@RES_CODE CHAR(12)
AS     
BEGIN
    
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		DECLARE @CODE         INT = 1
		       ,@MESSAGE      VARCHAR(4000) = '포인트 사용 취소 정상'
		
		IF EXISTS (
		       SELECT 1
		       FROM   dbo.CUS_POINT
		       WHERE  CUS_NO = @CUS_NO
		              AND POINT_NO = @POINT_NO
		   )
		BEGIN

			DELETE 
			FROM   dbo.CUS_POINT
			WHERE  CUS_NO = @CUS_NO
					AND POINT_NO = @POINT_NO
		
			DELETE 
			FROM   dbo.CUS_POINT_HISTORY
			WHERE  POINT_NO = @POINT_NO
		
			DELETE 
			FROM   DBO.PAY_MASTER_damo
			WHERE  PAY_SEQ IN (SELECT PAY_SEQ
								FROM   DBO.PAY_MATCHING
								WHERE  RES_CODE = @RES_CODE)

			DELETE
			FROM   DBO.PAY_MATCHING
			WHERE  RES_CODE = @RES_CODE		
		
		
			-- 결과 리터
			SELECT @CODE AS 'CODE'
			      ,@MESSAGE AS 'MESSAGE'
			
		END
		ELSE
		BEGIN
			
			RAISERROR('취소할 포인트가 없습니다.', 16, 1)
			
		END

					

				
	END TRY
	BEGIN CATCH
	
		-- 에러 결과 리터
		SELECT -1 AS 'CODE'
		      ,ERROR_MESSAGE() AS 'MESSAGE'

	END CATCH
         
END
GO
