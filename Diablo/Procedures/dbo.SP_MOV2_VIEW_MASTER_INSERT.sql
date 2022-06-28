USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_VIEW_MASTER_INSERT
■ DESCRIPTION				: 입력_조회중인마스터_행사상품
■ INPUT PARAMETER			: MASTER_CODE, PRO_CODE, SESSION_ID
■ EXEC						: 
    -- SP_MOV2_VIEW_MASTER_INSERT 'EPF365', 'EPF365-170630OK', '1332151121231'	

■ MEMO						: 조회중인마스터/행사상품 입력
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-02		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_VIEW_MASTER_INSERT]
	@MASTER_CODE	VARCHAR(10),
	@PRO_CODE		VARCHAR(20),
	@SESSION_ID		VARCHAR(100)
AS
BEGIN
		DECLARE @TMP_NO INT
		SELECT @TMP_NO = COUNT(*) FROM VIEW_MASTER WHERE PRO_CODE = @PRO_CODE AND SESSION_ID = @SESSION_ID		

		IF @TMP_NO < 1 
		BEGIN
			INSERT INTO VIEW_MASTER ( MASTER_CODE, PRO_CODE, SESSION_ID, NEW_DATE )
			VALUES ( @MASTER_CODE, @PRO_CODE, @SESSION_ID, GETDATE() )

			SELECT @@Identity
		END
		ELSE
			SELECT 0
END           



GO
