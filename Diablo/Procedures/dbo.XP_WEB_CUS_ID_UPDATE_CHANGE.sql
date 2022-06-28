USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_ID_UPDATE_CHANGE
■ DESCRIPTION				: 아이디 변경
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec  XP_WEB_CUS_ID_UPDATE_CHANGE 'dlehdgh48_','dlehdgh48'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-08-09		이동호			최초생성
================================================================================================================*/ 
CREATE  PROC [dbo].[XP_WEB_CUS_ID_UPDATE_CHANGE]
	@CUS_ID_OLD CHAR(18) ,
	@CUS_ID_NEW CHAR(18)
AS
BEGIN
	
	DECLARE @CUS_ID_OLD_CNT INT 
	DECLARE @CUS_ID_NEW_CNT INT

	SELECT @CUS_ID_OLD_CNT = COUNT(CUS_NO) FROM CUS_CUSTOMER WITH(NOLOCK) WHERE CUS_ID = @CUS_ID_OLD
	SELECT @CUS_ID_NEW_CNT = COUNT(CUS_NO) FROM CUS_CUSTOMER WITH(NOLOCK) WHERE CUS_ID = @CUS_ID_NEW

	IF(@CUS_ID_OLD_CNT > 0 AND @CUS_ID_NEW_CNT = 0)
		BEGIN
			UPDATE CUS_CUSTOMER SET CUS_ID = @CUS_ID_NEW WHERE CUS_ID = @CUS_ID_OLD
			UPDATE CUS_MEMBER SET CUS_ID = @CUS_ID_NEW WHERE CUS_ID = @CUS_ID_OLD			
		END
END
GO
