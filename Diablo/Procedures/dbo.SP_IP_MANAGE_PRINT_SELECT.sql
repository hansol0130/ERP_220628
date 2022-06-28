USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_IP_MANAGE_PRINT_SELECT
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
   2014-04-11		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_IP_MANAGE_PRINT_SELECT] 	
	@PRINT_CODE VARCHAR(10)
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		  PRINT_CODE
		, PRINT_NAME
		, MODEL_NAME
		, POSITION
		, DBO.XN_CUS_GET_IP_NUMBER(1, A.PRINT_CODE) AS [PC_IP]
		, EDI_CODE
		, REMARK
	FROM PRINT_MASTER A
	WHERE PRINT_CODE = @PRINT_CODE
END
	
GO
