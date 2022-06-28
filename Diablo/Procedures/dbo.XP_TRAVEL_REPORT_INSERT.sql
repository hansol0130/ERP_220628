USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_TRAVEL_REPORT_INSERT
■ DESCRIPTION				: 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

exec XP_TRAVEL_REPORT_INSERT 'EPP4983-190326', 'T140262'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   사용X
================================================================================================================*/ 
CREATE PROC [dbo].[XP_TRAVEL_REPORT_INSERT]
(
 	@PRO_CODE NVARCHAR(20),
	@NEW_CODE NVARCHAR(10)
)
AS 
BEGIN
	--DECLARE @OTR_SEQ NVARCHAR(10)

	IF (SELECT 1 FROM TRAVEL_REPORT_MASTER WITH(NOLOCK) WHERE PRO_CODE = @PRO_CODE) IS NULL
	BEGIN
		INSERT INTO TRAVEL_REPORT_MASTER(OTR_STATE, PRO_CODE, NEW_CODE, NEW_DATE)
		VALUES(0, @PRO_CODE, @NEW_CODE, GETDATE())
	END
END 


GO
