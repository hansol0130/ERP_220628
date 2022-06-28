USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_COM_CLIENT_CARD_INFO_UPDATE
■ DESCRIPTION				: BTMS 거래처 카드 정보 수정
■ INPUT PARAMETER			: AGT_CODE
■ OUTPUT PARAMETER			: 
■ EXEC						: 	
	EXEC XP_COM_CLIENT_CARD_INFO_UPDATE
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2016-04-13		저스트고강태영			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_COM_CLIENT_CARD_INFO_UPDATE]
	@AGT_CODE varchar(10), @ACC_SEQ INT, @REG_NAME varchar(30), @ACC_NAME varchar(50),
	@REG_NUMBER varchar(20), @ADMIN_REMARK varchar(300),@SHOW_YN char(1), @NEW_CODE CHAR(7), @EDT_CODE CHAR(7)
AS 
BEGIN
		INSERT INTO AGT_ACCOUNT
		(
			AGT_CODE,
			ACC_SEQ,
			REG_NAME,
			ACC_NAME,
			REG_NUMBER,
			ADMIN_REMARK,
			SHOW_YN,
			NEW_DATE,
			NEW_CODE,
			EDT_DATE,
			EDT_CODE
		)
		VALUES
		(
			@AGT_CODE,
			@ACC_SEQ,
			@REG_NAME,
			@ACC_NAME,
			@REG_NUMBER,
			@ADMIN_REMARK,
			@SHOW_YN,
			GETDATE(),
			@NEW_CODE,
			GETDATE(),
			@EDT_CODE
		)

END 
GO
