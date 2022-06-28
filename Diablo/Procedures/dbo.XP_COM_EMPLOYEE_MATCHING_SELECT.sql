USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_COM_EMPLOYEE_MATCHING_SELECT
■ DESCRIPTION				: 출장 직원 CUS_NO 매핑 조회
■ INPUT PARAMETER			: 
	
	XP_COM_EMPLOYEE_MATCHING_SELECT  '92756' ,122  

■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-03-02		박형만			최초생성    
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_EMPLOYEE_MATCHING_SELECT]
(
	@AGT_CODE VARCHAR(10),
	@EMP_SEQ INT
)
AS 
BEGIN
	SELECT TOP 1 * FROM COM_EMPLOYEE_MATCHING WITH(NOLOCK)
	WHERE AGT_CODE = @AGT_CODE
	AND EMP_SEQ = @EMP_SEQ
END 

GO
