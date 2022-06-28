USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_RES_CUSTOMER_BASIC_UPDATE 
■ DESCRIPTION				: 출발자 정보 업데이트 ( 발송정보에 신규로 들어감.. 기본정보 이름, 핸드폰, 이메일 )
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
    2018-06-13		정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_RES_CUSTOMER_BASIC_UPDATE]
	@SEQ_NO INT,
	@NOR_TEL1 VARCHAR(6),
	@NOR_TEL2 VARCHAR(5),
	@NOR_TEL3 VARCHAR(4),
	@EMAIL VARCHAR(40),
	@RES_CODE VARCHAR(12),
	@NEW_CODE CHAR(7)
AS 
BEGIN
	IF @SEQ_NO = 0 
	BEGIN
		UPDATE RES_MASTER_DAMO SET 
			NOR_TEL1 = @NOR_TEL1,
			NOR_TEL2 = @NOR_TEL2,
			NOR_TEL3 = @NOR_TEL3,
			RES_EMAIL = @EMAIL,
			EDT_DATE = GETDATE(),
			EDT_CODE = @NEW_CODE 
		WHERE RES_CODE = @RES_CODE 
	END 
	ELSE 
	BEGIN
		UPDATE RES_CUSTOMER_DAMO SET 
			NOR_TEL1 = @NOR_TEL1,
			NOR_TEL2 = @NOR_TEL2,
			NOR_TEL3 = @NOR_TEL3,
			EMAIL = @EMAIL,
			EDT_DATE = GETDATE(),
			EDT_CODE = @NEW_CODE
		WHERE RES_CODE = @RES_CODE 
		AND	SEQ_NO = @SEQ_NO 
	END
END


GO
