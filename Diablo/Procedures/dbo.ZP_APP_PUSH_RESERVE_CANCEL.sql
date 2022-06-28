USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: ZP_APP_PUSH_RESERVE_CANCEL
■ DESCRIPTION				: 설문조사 선택 데이터 저장(맞춤검색)
■ INPUT PARAMETER			: 
	@SEND_SEQ			int		: 송신번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	EXEC ZP_APP_PUSH_RESERVE_CANCEL ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-06-24		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_APP_PUSH_RESERVE_CANCEL]
	@SEND_SEQ		INT
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	UPDATE APP_PUSH_SEND_HISTORY
	SET    CANCEL_YN = 'Y'
	WHERE  SEND_SEQ = @SEND_SEQ

END
GO
