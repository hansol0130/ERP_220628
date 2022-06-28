USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: ZP_EXCEL_CUSNO_INSERT
■ DESCRIPTION				: 입력_엑셀_고객번호
■ INPUT PARAMETER			: CUS_NO_ALL
■ EXEC						: 
    -- EXEC ZP_EXCEL_CUSNO_INSERT '1', '4797216,12565618'

■ MEMO						: 엑셀파일로 전송대상 고객번호 입력
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-08-20		홍종우					푸시전송 시 엑셀파일로 전송대상 고객번호 입력
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_EXCEL_CUSNO_INSERT]
	@MSG_NO INT,
	@CUS_NO_ALL VARCHAR(MAX)
AS
BEGIN
	
	INSERT INTO APP_PUSH_CUSNO_EXCEL
	SELECT @MSG_NO, CONVERT(INT,VALUE), GETDATE()
	FROM STRING_SPLIT(@CUS_NO_ALL,',')

END           



GO
