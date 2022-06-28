USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DOC_NOTE_INSERT]
	@EDI_CODE		CHAR(10),
	@EMP_CODE		CHAR(7),
	@MESSAGE		VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
	@NEW_CODE			VARCHAR(1000),		-- 받는사람코드 (2008011)
	@SEND_CAT_SEQ_NO	INT,				-- 0
	@CONTENTS			VARCHAR(MAX),		-- 내용
	@SUBJECT			VARCHAR(100),		-- 제목
	@SEND_CODE			VARCHAR(7)			-- 보낸사람코드	

	SELECT 
		@NEW_CODE = NEW_CODE,	@SEND_CAT_SEQ_NO = 0,
		@CONTENTS = '"' + [SUBJECT] + '" 문서가 처리되었습니다.',
		@SUBJECT = '[' + (CASE DOC_TYPE
					WHEN '1' THEN '휴가계'
					WHEN '2' THEN '출장계'
					WHEN '3' THEN '기안서'
					WHEN '4' THEN '일반지결서'
					WHEN '5' THEN '업무협조문'
					WHEN '6' THEN '발권요청서'
					WHEN '7' THEN '경영지원실 경유기안'
					WHEN '8' THEN '행사지결서'
					ELSE '전자결재문서' END) + '](이)가 ' + @MESSAGE + '되었습니다',
		@SEND_CODE = @EMP_CODE
	FROM EDI_MASTER_DAMO
	WHERE EDI_CODE = @EDI_CODE

	-- 쪽지 발송
	EXEC SP_PRI_NOTE_INSERT @NEW_CODE, @SEND_CAT_SEQ_NO, @CONTENTS, @SUBJECT, @NEW_CODE

END


GO
