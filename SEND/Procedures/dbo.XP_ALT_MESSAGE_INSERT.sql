USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_ALT_MESSAGE_INSERT
■ DESCRIPTION				: 알림톡 발송 메세지 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-05-18		김성호			최초생성
   2018-06-06		정지용			CUS_NAME, AGT_CODE, EMP_SEQ 추가 ( BTMS 매칭용 )
   2018-12-19		박형만			버튼(ATTACHMENT  JSON 형식)추가 
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_ALT_MESSAGE_INSERT]
	@SENDER_KEY		VARCHAR(40),		-- [엠앤와이즈에서 발급한 발신프로필키]
	@PHONE_NUM		VARCHAR(16),		-- [수신자휴대폰번호] : 숫자만 입력 예) 01023456789
	@TMPL_CD		VARCHAR(20),		-- [카카오 승인된 알림톡 템플릿코드]
	@SND_MSG		NVARCHAR(1000),		-- [카카오 승인된 알림톡 템플릿에 데이터 매핑된 발송메시지] : 임의의 메시지 입력시 템플릿불일치(3016 에러)로 발송실패됨
	@REQ_DTM		VARCHAR(14),		-- [발송요청일시] 예) 2018 05 10 11 06 00 (yyyymmdd24miss)
	@SUBJECT		VARCHAR(40),		-- [LMS 제목]
	@SMS_SND_NUM	VARCHAR(16),		-- [사전등록된 발신자 전화번호]
	@REQ_DEPT_CD	VARCHAR(50),		-- [발송요청부서코드]
	@REQ_USR_ID		VARCHAR(50),		-- [발송요청자ID]
	@SMS_SND_YN		VARCHAR(1) = 'Y',	-- [알림톡 발송실패시 문자우회발송여부] : [Y: 발송함, N: 발송안함(기본값)]
	@TR_TYPE_CD		VARCHAR(1) = 'B',	-- [발송유형] : [R : 실시간발송 B : 배치발송(기본값)] 
	@RES_CODE		VARCHAR(12),		-- [예약코드]
	@CUS_NO			INT,				-- [고객코드]
	@CUS_NAME		VARCHAR(20) = NULL, -- [고객명]
	@AGT_CODE		VARCHAR(10) = NULL, -- [업체코드]
	@EMP_SEQ		INT = NULL,			-- [업체직원코드]
	@ATTACHMENT		VARCHAR(4000)=NULL	-- [버튼JSON STRING]
AS
BEGIN

	DECLARE
		@TODAY		VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112),
		@SN			VARCHAR(100),		-- [발송요청ID]
		@CHANNEL	VARCHAR(1) = 'A',	-- CHANNEL (채널) : [A: 알림톡]
		@SEND_TYPE	VARCHAR(1) = 'R'	-- [알림톡 발송방식] : [P: Push(기본값), R: Realtime]


	-- 실패시 SMS 발송 유무
	IF ISNULL(@SMS_SND_YN, '') = ''
		SET  @SMS_SND_YN = 'Y';


	-- SN 생성
	EXEC SEND.DBO.XP_ALT_SN_SELECT @SN_DATE = @TODAY, @SN = @SN OUTPUT;


	-- 메세지 마스터 등록 (삭제예정)
	--INSERT INTO SEND.dbo.ALT_SEND_MASTER (SN, RES_CODE, CUS_NO, NEW_DATE, AGT_CODE, EMP_SEQ, CUS_NAME)
	--VALUES (@SN, @RES_CODE, @CUS_NO, GETDATE(), @AGT_CODE, @EMP_SEQ, @CUS_NAME)


	-- 메세지 마스터 등록 (신규)
	INSERT INTO SEND.dbo.ALT_MESSAGE_MASTER (SN, RES_CODE, CUS_NO, CUS_NAME, AGT_CODE, EMP_SEQ)
	VALUES (@SN, @RES_CODE, @CUS_NO, @CUS_NAME, @AGT_CODE, @EMP_SEQ)


	-- 메세지 본문 등록
	INSERT INTO SEND.dbo.MZSENDTRAN ( SN, SENDER_KEY, CHANNEL, SND_TYPE, PHONE_NUM, TMPL_CD, SND_MSG, REQ_DTM,  SUBJECT, SMS_SND_NUM, REQ_DEPT_CD, REQ_USR_ID, SMS_SND_YN, TR_TYPE_CD ,ATTACHMENT )
	VALUES (
		@SN,			-- [발송요청ID]
		@SENDER_KEY,	-- [엠앤와이즈에서 발급한 발신프로필키]
		@CHANNEL,		-- CHANNEL (채널) : [A: 알림톡]
		@SEND_TYPE,		-- [알림톡 발송방식] : [P: Push(기본값), R: Realtime]
		@PHONE_NUM,		-- [수신자휴대폰번호] : 숫자만 입력 예) 01023456789
		@TMPL_CD,		-- [카카오 승인된 알림톡 템플릿코드]
		@SND_MSG,		-- [카카오 승인된 알림톡 템플릿에 데이터 매핑된 발송메시지] : 임의의 메시지 입력시 템플릿불일치(3016 에러)로 발송실패됨
		@REQ_DTM,		-- [발송요청일시] 예) 2018 05 10 11 06 00 (yyyymmdd24miss)
		@SUBJECT,		-- [LMS 제목]
		@SMS_SND_NUM,	-- [사전등록된 발신자 전화번호]
		@REQ_DEPT_CD,	-- [등록팀]
		@REQ_USR_ID,	-- [등록 사원코드]
		@SMS_SND_YN,	-- [알림톡 발송실패시 문자우회발송여부] : [Y: 발송함, N: 발송안함(기본값)]
		@TR_TYPE_CD,	-- [발송유형] : [R : 실시간발송 B : 배치발송(기본값)] 
		@ATTACHMENT		-- [버튼] : [{"button" : [{ "name" : "주문정보 보기", "type" : "WL", "url_mobile" : "http://www.kakao.com" }]}] 
	);

	--BEGIN TRY
	--	BEGIN TRAN

	--		-- SN 생성
	--		--IF EXISTS(SELECT 1 FROM SEND.dbo.MZSENDTRAN A WITH(NOLOCK) WHERE A.SN LIKE (@TODAY + '%'))
	--		IF EXISTS(SELECT TOP 1 1 FROM SEND.dbo.MZSENDTRAN A WITH(NOLOCK) WHERE A.SN LIKE (@TODAY + '%'))	
	--				OR EXISTS(SELECT TOP 1 1 FROM SEND.dbo.MZSENDLOG B WITH(NOLOCK) WHERE B.SN LIKE (@TODAY + '%'))
	--		BEGIN
	--			--SELECT '20180514' + CONVERT(VARCHAR(6), RIGHT(('000000' + CONVERT(VARCHAR(6), CONVERT(INT, SUBSTRING('20180514009999', 9, 6)) + 1)), 6))

	--			SELECT @SN = @TODAY + CONVERT(VARCHAR(6), RIGHT(('00000' + CONVERT(VARCHAR(5), CONVERT(INT, SUBSTRING(MAX(A.SN), 9, 6)) + 1)), 6))
	--			FROM (
	--				SELECT A.SN FROM SEND.dbo.MZSENDTRAN A WITH(NOLOCK) WHERE A.SN LIKE (@TODAY + '%')
	--				UNION
	--				SELECT B.SN FROM SEND.dbo.MZSENDLOG B WITH(NOLOCK) WHERE B.SN LIKE (@TODAY + '%')
	--			) A
	--		END
	--		ELSE
	--		BEGIN
	--			SELECT @SN = @TODAY + '000001'
	--		END

	--		-- 메세지 마스터 등록
	--		INSERT INTO SEND.dbo.ALT_SEND_MASTER (SN, RES_CODE, CUS_NO, NEW_DATE)
	--		VALUES (@SN, @RES_CODE, @CUS_NO, GETDATE())
	
	--		-- 메세지 본문 등록
	--		INSERT INTO SEND.dbo.MZSENDTRAN ( SN, SENDER_KEY, CHANNEL, SND_TYPE, PHONE_NUM, TMPL_CD, SND_MSG, REQ_DTM,  SUBJECT, SMS_SND_NUM, SMS_SND_YN, TR_TYPE_CD )
	--		VALUES (
	--			@SN,			-- [발송요청ID]
	--			@SENDER_KEY,	-- [엠앤와이즈에서 발급한 발신프로필키]
	--			@CHANNEL,		-- CHANNEL (채널) : [A: 알림톡]
	--			@SEND_TYPE,		-- [알림톡 발송방식] : [P: Push(기본값), R: Realtime]
	--			@PHONE_NUM,		-- [수신자휴대폰번호] : 숫자만 입력 예) 01023456789
	--			@TMPL_CD,		-- [카카오 승인된 알림톡 템플릿코드]
	--			@SND_MSG,		-- [카카오 승인된 알림톡 템플릿에 데이터 매핑된 발송메시지] : 임의의 메시지 입력시 템플릿불일치(3016 에러)로 발송실패됨
	--			@REQ_DTM,		-- [발송요청일시] 예) 2018 05 10 11 06 00 (yyyymmdd24miss)
	--			@SUBJECT,		-- [LMS 제목]
	--			@SMS_SND_NUM,	-- [사전등록된 발신자 전화번호]
	--			@SMS_SND_YN,	-- [알림톡 발송실패시 문자우회발송여부] : [Y: 발송함, N: 발송안함(기본값)]
	--			@TR_TYPE_CD		-- [발송유형] : [R : 실시간발송 B : 배치발송(기본값)] 
	--		);

	--	COMMIT TRAN
	--END TRY
	--BEGIN CATCH

	--	ROLLBACK TRAN

	--	-- 실패 시 NULL 출력
	--	SET @SN = NULL

	--END CATCH

	SELECT @SN
 
END

/*

--DROP TABLE dbo.ALT_SEND_MASTER

CREATE TABLE dbo.ALT_SEND_MASTER
(
	SN			VARCHAR(100) NOT NULL,
    RES_CODE	VARCHAR(12) NULL,
    CUS_NO		INT NULL,
	NEW_DATE	DATETIME
);


CREATE TABLE dbo.ALT_RESULT_MESSAGE
(
	RST_TYPE	CHAR(1) NOT NULL,
	RST_CODE	VARCHAR(5) NOT NULL,
	RST_TITLE	VARCHAR(100) NULL,
	RST_INFO	VARCHAR(4000) NULL
);


*/

GO
