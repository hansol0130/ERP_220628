USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_PRINT_UPDATE
■ DESCRIPTION				: 사내 IP관리 주변기기 마스터
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2014-04-11		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_PRINT_UPDATE]
 	@PRINT_CODE VARCHAR(10),
	@PRINT_NAME VARCHAR(20),
	@MODEL_NAME VARCHAR(20),
	@POSITION VARCHAR(50),
	@EDI_CODE VARCHAR(10),
	@REMARK VARCHAR(100),
	@EDT_CODE CHAR(7)
AS 
BEGIN
	SET NOCOUNT OFF;

	UPDATE PRINT_MASTER SET
		PRINT_NAME = @PRINT_NAME,
		MODEL_NAME = @MODEL_NAME,
		POSITION = @POSITION,
		EDI_CODE = @EDI_CODE,
		REMARK = @REMARK,
		EDT_CODE = @EDT_CODE,
		EDT_DATE = GETDATE()
	WHERE PRINT_CODE = @PRINT_CODE

END
GO
