USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_PRINT_DELETE
■ DESCRIPTION				: 사내 IP관리 삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-04-23		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_PRINT_DELETE]
 	@IP_TYPE  INT, -- 1 :PC, 2 : 전화기
	@CONNECT_CODE VARCHAR(10)
AS 
BEGIN
	SET NOCOUNT OFF;

	IF EXISTS ( SELECT 1 FROM IP_MASTER WHERE CONNECT_CODE = @CONNECT_CODE AND IP_TYPE = @IP_TYPE )
	BEGIN
		DELETE FROM IP_MASTER WHERE CONNECT_CODE = @CONNECT_CODE AND IP_TYPE = @IP_TYPE
		DELETE FROM PRINT_MASTER WHERE PRINT_CODE = @CONNECT_CODE
	END
END
	

GO
