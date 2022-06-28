USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ACR_CONFIRM_UPDATE
■ DESCRIPTION				: 경위서 확인자 업데이트
■ INPUT PARAMETER			: 
	@ACR_SEQ_NO INT			: 경위서 순번
	@CFM_CODE VARCHAR(7)	: 수정자 코드
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	
	EXEC DBO.XP_ACR_CONFIRM_UPDATE 1, '9999999'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-06-19		김완기			최초생성
   2014-01-14		김성호			쿼리수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ACR_CONFIRM_UPDATE]
	@ACR_SEQ_NO INT ,
	@CFM_CODE VARCHAR(7)
AS 
BEGIN

	IF (SELECT LEN(ISNULL(CFM_CODE, '')) FROM ACR_MASTER WITH(NOLOCK) WHERE ACR_SEQ_NO = @ACR_SEQ_NO) < 7
	BEGIN
		UPDATE ACR_MASTER SET CFM_DATE = GETDATE(), CFM_CODE = @CFM_CODE
		WHERE ACR_SEQ_NO = @ACR_SEQ_NO
	END

	--DECLARE @CHECK_CFM_CODE VARCHAR(10);

	--SELECT  @CHECK_CFM_CODE = CFM_CODE
	--  FROM  ACR_MASTER
	-- WHERE  ACR_SEQ_NO =  @ACR_SEQ_NO

	--IF ISNULL(@CHECK_CFM_CODE, '') = ''
	--	BEGIN
	--		UPDATE ACR_MASTER
	--		SET CFM_DATE = GETDATE(), CFM_CODE = @CFM_CODE
	--		WHERE ACR_SEQ_NO =  @ACR_SEQ_NO
	--	END
END


GO
