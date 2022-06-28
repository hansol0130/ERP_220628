USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: [onetime].[ZP_ALMIMTALK_NEWS_LETTER]
■ DESCRIPTION				: H등급_희망레터발송
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2022-02-09		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [onetime].[ZP_ALMIMTALK_NEWS_LETTER]
AS 
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	/*
	 *
		1. 발송 대상: onetime.RES_HOPE_CUS_TEL_LIST
		2. 발송 시점: 2022-02-09 오후
		3. 템플릿 : SYS_AT_0187
		
		[참좋은여행]
		안녕하세요 고객님

		#{월} 희망레터가 도착했습니다.

		희망등급 고객님들께는 여행을 떠날 수 있는 그 날까지,
		다양한 여행 정보 및 이벤트·혜택에 대해 알려드립니다.

		아래의 버튼을 누르시면 #{월} 희망레터로 이동합니다.

		* 해당 메시지는 희망을 예약하신 고객님께 발송됩니다.


		4. 참고
		-- 알림톡 발송 전 (발송후 이 테이블에서 삭제하고 SEND.dbo.MZSENDLOG 에 로그 저장)
		SELECT * FROM SEND.dbo.MZSENDTRAN
		WHERE TMPL_CD = 'SYS_AT_0187'

		-- 알림톡 발송 후
		SELECT * FROM SEND.dbo.MZSENDLOG
		WHERE TMPL_CD = 'SYS_AT_0187'
		ORDER BY SN DESC

	 * 
	 */	
	
	
	
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD        VARCHAR(20) = 'SYS_AT_0187'	-- 사용 템플릿 번호
	       ,@CONTS_TXT      VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       
	       ,@HH             VARCHAR(2) = '10' -- 시간
	       ,@MM             VARCHAR(2) = '00' -- 분
	       ,@REQ_DTM        VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMdd') -- 알림톡 발송일시 (금일 오전 10시로 예약)

		   ,@SUBJECT        VARCHAR(40) = 'H등급_희망레터발송' -- 알림톡제목(SMS 발송시 필요)
		   ,@SMS_SND_YN     VARCHAR(1) = 'N' -- Y: 알림톡 실패시 SMS 전송, N: 알림톡 실패시 SMS 전송 안함
		   ,@TR_TYPE_CD     VARCHAR(1) = 'B' -- R: 실시간발송, B:예약발송
	
	SET @REQ_DTM = @REQ_DTM + @HH + @MM + '00'


	SELECT @CONTS_TXT_TEMP = CONTS_TXT
	FROM   SEND.dbo.NVMOBILECONTENTS
	WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	
	       
	/*
	 * 대상자 알림톡 발송
	 */

	DECLARE @CUS_TEL_cur VARCHAR(11)
	
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT NOR_TEL AS 'CUS_TEL'
	FROM onetime.RES_HOPE_CUS_TEL_LIST
	WHERE NOR_TEL LIKE '010%'
	
	-- For Test (허예설)
	--SELECT TOP 1 '01027341135' AS 'CUS_TEL'
	--FROM onetime.RES_HOPE_CUS_TEL_LIST
	--WHERE NOR_TEL LIKE '010%'
	
	
	OPEN my_cursor
	
	
	
	FETCH FROM my_cursor INTO @CUS_TEL_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{월}', '2월')

		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    											 ,@PHONE_NUM= @CUS_TEL_cur
    											 ,@TMPL_CD = @TMPL_CD
    											 ,@SND_MSG = @CONTS_TXT
    											 ,@REQ_DTM = @REQ_DTM
    											 ,@SUBJECT = @SUBJECT
    											 ,@SMS_SND_NUM = '0221884000' -- 대표번호
    											 ,@REQ_DEPT_CD = '518' -- 마케팅 부서코드
    											 ,@REQ_USR_ID = '9999999'
    											 ,@SMS_SND_YN = @SMS_SND_YN -- Y: 알림톡 실패시 SMS 전송, N: 알림톡 실패시 SMS 전송 안함
    											 ,@TR_TYPE_CD = @TR_TYPE_CD -- R: 실시간발송, B:예약발송
    											 ,@RES_CODE = NULL -- 예약번호가 있는 경우 입력
    											 ,@CUS_NO = NULL -- 정회원인 경우 입력
    											 ,@AGT_CODE = NULL
    											 ,@EMP_SEQ = NULL
    											 ,@CUS_NAME = NULL -- 정회원인 경우 입력
												 ,@ATTACHMENT = '{
																	"button": [
																		{
																			"name": "채널 추가",
																			"type": "AC"
																		},
																		{
																			"name": "희망레터",
																			"type": "WL",
																			"url_mobile": "https://m.verygoodtour.com/WebZine/WebZineView?BoardSeq=485",
																			"url_pc": "https://www.verygoodtour.com/Board/BoardCommonView?MenuCode=10902&MasterSeq=16&BoardSeq=485"
																		}
																	]
																}'
	
		FETCH FROM my_cursor INTO @CUS_TEL_cur
	END
	
	CLOSE my_cursor
	DEALLOCATE my_cursor
	
	


END

GO
