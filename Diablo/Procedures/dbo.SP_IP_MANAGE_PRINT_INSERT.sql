USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_PRINT_INSERT
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
CREATE PROC [dbo].[SP_IP_MANAGE_PRINT_INSERT]
 	@PRINT_CODE VARCHAR(10),
	@PRINT_NAME VARCHAR(20),
	@MODEL_NAME VARCHAR(20),
	@POSITION VARCHAR(50),
	@EDI_CODE VARCHAR(10),
	@REMARK VARCHAR(100),
	@NEW_CODE CHAR(7)
AS 
BEGIN
	SET NOCOUNT OFF;

	INSERT INTO PRINT_MASTER (
		PRINT_CODE, PRINT_NAME, MODEL_NAME, POSITION, EDI_CODE, REMARK, NEW_CODE, NEW_DATE
	)
	VALUES(
		@PRINT_CODE, @PRINT_NAME, @MODEL_NAME, @POSITION, @EDI_CODE, @REMARK, @NEW_CODE, GETDATE()
	)
END
GO
