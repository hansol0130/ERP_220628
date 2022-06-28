USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_EVT_PROMOTION_SHARE
■ DESCRIPTION				: 프로모션 이벤트 공유 횟수 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2017-05-02		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_EVT_PROMOTION_SHARE]
	@SEC_SEQ INT,
 	@SEQ_NO INT,
	@CUS_NO INT,
	@SHARE_NAME VARCHAR(20),
	@IPADDRESS VARCHAR(50)
AS 
BEGIN
	SET NOCOUNT OFF;

	INSERT INTO EVT_PROMOTION_DETAIL_SHARE ( SEC_SEQ, SEQ_NO, CUS_NO, SHARE_NAME, IPADDRESS, NEW_DATE )
	VALUES ( @SEC_SEQ, @SEQ_NO, @CUS_NO, @SHARE_NAME, @IPADDRESS, GETDATE() )	

END


GO
