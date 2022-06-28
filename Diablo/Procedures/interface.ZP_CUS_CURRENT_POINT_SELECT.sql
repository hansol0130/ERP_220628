USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
/*================================================================================================================    
■ USP_NAME     : [ZP_CUS_CURRENT_POINT_SELECT]    
■ DESCRIPTION    : 현재 고객 포인트 조회    
■ INPUT PARAMETER   :     
■ OUTPUT PARAMETER   :     
■ EXEC      :     
■ MEMO      :     
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
   DATE    AUTHOR   DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
   2020-12-09  오준혁   최초생성    
================================================================================================================*/     
CREATE PROCEDURE [interface].[ZP_CUS_CURRENT_POINT_SELECT]
	@CUS_NO INT
AS     
BEGIN
    
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT TOP 1 TOTAL_PRICE AS CURRENT_POINT
	FROM   dbo.CUS_POINT
	WHERE  CUS_NO = @CUS_NO
	ORDER BY
	       POINT_NO DESC
	       
         
END
GO
