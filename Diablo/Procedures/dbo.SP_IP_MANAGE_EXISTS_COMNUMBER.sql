USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_EXISTS_COMNUMBER
■ DESCRIPTION				: 사내 IP관리
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2016-09-07		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_EXISTS_COMNUMBER]
 	@COM_NUMBER  VARCHAR(10)
AS 
BEGIN
	IF EXISTS(SELECT 1 FROM IP_MASTER WITH(NOLOCK) WHERE COM_NUMBER = @COM_NUMBER) AND @COM_NUMBER <> ''
	BEGIN
		SELECT 0;
		RETURN;
	END
	SELECT 1;
END

GO
