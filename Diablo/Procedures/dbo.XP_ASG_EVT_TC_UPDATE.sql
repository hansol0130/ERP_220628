USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_ASG_EVT_TC_UPDATE
■ DESCRIPTION				: 대외업무시스템 인솔자 배정행사 등록
■ INPUT PARAMETER			: 
	@PRO_CODE	VARCHAR(20), : 행사코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_ASG_EVT_TC_UPDATE 'JPP987-130311016A', '1'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-25		이상일			최초생성    
================================================================================================================*/ 

 CREATE PROCEDURE [dbo].[XP_ASG_EVT_TC_UPDATE]
(
	@PRO_CODE	VARCHAR(20),
	@TC_CODE	VARCHAR(20),
	@TC_NAME	VARCHAR(20),
	@EDT_CODE	VARCHAR(20),
	@ASSIGN_YN  VARCHAR(1)
)

AS  
BEGIN
	IF @ASSIGN_YN = 'Y'
		BEGIN
			UPDATE PKG_DETAIL SET 
				TC_CODE = @TC_CODE, 
				TC_NAME = @TC_NAME, 
				TC_ASSIGN_YN = 'Y',
				TC_ASSIGN_DATE = GETDATE(),
				EDT_CODE = @EDT_CODE,
				EDT_DATE = GETDATE()
			WHERE PRO_CODE = @PRO_CODE
		END
	ELSE IF @ASSIGN_YN = 'N'
		BEGIN
			UPDATE PKG_DETAIL SET 
				TC_CODE = '', 
				TC_NAME = '', 
				TC_ASSIGN_YN = 'N',
				TC_ASSIGN_DATE = GETDATE(),
				EDT_CODE = @EDT_CODE,
				EDT_DATE = GETDATE()
			WHERE PRO_CODE = @PRO_CODE
		END
END


GO
