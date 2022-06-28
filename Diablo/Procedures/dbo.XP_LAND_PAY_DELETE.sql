USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_LAND_PAY_DELETE
■ DESCRIPTION				: 랜드사 지상비 삭제
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DBO.XP_LAND_PAY_DELETE 'APP5042-130925', 4, 0
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-10-14		김완기			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_LAND_PAY_DELETE]
	@PRO_CODE	VARCHAR(20), 
	@LAND_SEQ_NO INT,
	@RESULT INT OUTPUT
AS 
BEGIN
	
	DECLARE @DOC_YN VARCHAR(1)
	SET @RESULT = 0

	SELECT @DOC_YN = DOC_YN FROM SET_LAND_AGENT WHERE PRO_CODE = @PRO_CODE AND LAND_SEQ_NO = @LAND_SEQ_NO

	IF @DOC_YN = 'N'
		BEGIN
			DELETE FROM SET_LAND_CUSTOMER WHERE PRO_CODE = @PRO_CODE AND LAND_SEQ_NO = @LAND_SEQ_NO
			
			DELETE FROM SET_LAND_AGENT WHERE PRO_CODE = @PRO_CODE AND LAND_SEQ_NO = @LAND_SEQ_NO

			SET @RESULT = 1
		END
	ELSE IF @DOC_YN = 'Y'
		BEGIN
			SET @RESULT = -1
		END


	SELECT @RESULT
END 

GO
