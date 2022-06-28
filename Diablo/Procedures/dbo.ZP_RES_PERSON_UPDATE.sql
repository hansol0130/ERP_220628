USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_RESERVATION_PERSON_UPDATE
■ DESCRIPTION				: 예약상품의 담당자 변경
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec ZP_RESERVATION_PERSON_UPDATE 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2022-03-15		오정민			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_RES_PERSON_UPDATE]
(
	@RES_CODE	VARCHAR(12),
	@NEW_CODE	VARCHAR(7)
) AS 
BEGIN
	
	SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
	UPDATE dbo.RES_MASTER_damo 
	SET  NEW_CODE = @NEW_CODE 
	WHERE RES_CODE = @RES_CODE

END 
GO
