USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: ZP_EVT_CHANGE_DORMANT_MEMBER_INSERT
■ DESCRIPTION				: 휴면회원 정회원 전환 이벤트 입력
■ INPUT PARAMETER			: 
	@CUS_NO			INT		: 고객고유번호
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	EXEC ZP_EVT_CHANGE_DORMANT_MEMBER_INSERT ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-07-16		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_EVT_CHANGE_DORMANT_MEMBER_INSERT]
	@CUS_NO			INT
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF EXISTS(
	       SELECT 1
	       FROM   EVT_CHANGE_DORMANT_MEMBER_TARGET TG
	       WHERE  TG.CUS_NO = @CUS_NO
	   )
	BEGIN
	    IF NOT EXISTS(
	           SELECT 1
	           FROM   EVT_CHANGE_DORMANT_MEMBER ED
	           WHERE  ED.CUS_NO = @CUS_NO
	       )
	    BEGIN
	        INSERT INTO EVT_CHANGE_DORMANT_MEMBER
	          (
	            CUS_NO
	           ,NEW_DATE
	          )
	        VALUES
	          (
	            @CUS_NO
	           ,GETDATE()
	          )
	        SELECT 1
	    END
	END
END
GO
