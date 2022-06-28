USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: onetime.ZP_CUS_SND_TVCF
■ DESCRIPTION				: TV CF 알림톡 요청 (전화번호 보유 회원 대상 알림톡 발송 요청) #1605
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-12-01		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [onetime].[ZP_EVT_LONGTERM_UNUSED_V2]
AS 
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	/*
	 *
		1. 템플릿코드 : SYS_AT_0178
		2. 템플릿유형 : 광고 추가형
		3. 템플릿명 : 장기 미이용에 따른 개인정보 파기에 대한 안내(채널추가)
		
		4. 내용 :
		----------------------------
		[참좋은여행]

		장기 미이용 고객 대상 안내사항


		고객님의 개인정보 보호를 위해 2021년 말 기준으로 5년 이상 경과된 
		소중한 여행 기록 및 예약 내역 등의 모든 개인정보가 파기될 예정입니다.

		소중한 추억이 사라지길 원치 않는 고객님께서는
		기한 내 아래 페이지에 접속하여 <개인정보 통합> 버튼을 통해 회원정보를 통합하여 주시기 바랍니다.

		■ 통합 요청 기한 : #{통합 기한}
		■ 개인정보 파기 예정일 : #{파기 일자}
		■ 회원정보 통합하기 : #{회원정보 통합페이지 url}


		5. 변수 :
		#{통합 기한} : 2021년 12월 31일
		#{파기 일자} : 20222년 1월 10일
		#{회원정보 통합페이지 url} : http://vgt.kr/u/Xxy5

		
	 * 
	 */	
	
	
	
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD       VARCHAR(20) = 'SYS_AT_0178'	-- 사용 템플릿 번호
	       ,@CONTS_TXT     VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       ,@REQ_DTM       VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMdd100000') -- 알림톡 발송일시 (금일 오전 10시로 예약)

	SELECT @CONTS_TXT_TEMP = CONTS_TXT
	FROM   SEND.dbo.NVMOBILECONTENTS
	WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	
	       
	/*
	 * 알림톡 대상자
	 */
	DECLARE @CUS_NO_cur       INT
	       ,@CUS_TEL_cur      VARCHAR(11)


	       
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT a.CUS_NO AS 'CUS_NO'
	      ,a.TELNUMBER AS 'CUS_TEL'
	FROM   onetime.EVT_LONGTERM_UNUSED2 a

	
	OPEN my_cursor

	FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_TEL_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{통합 기한}', '2021년 12월 31일')
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{파기 일자}', '2022년 1월 10일')
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{회원정보 통합페이지 url}', 'http://vgt.kr/u/Xxy5')
		 
		-- 알림톡 발송
		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    											 ,@PHONE_NUM= @CUS_TEL_cur
    											 ,@TMPL_CD = @TMPL_CD
    											 ,@SND_MSG = @CONTS_TXT
    											 ,@REQ_DTM = @REQ_DTM
    											 ,@SUBJECT = '장기 미이용 고객 대상 안내문'
    											 ,@SMS_SND_NUM = '0221884000'
    											 ,@REQ_DEPT_CD = '529'
    											 ,@REQ_USR_ID = '9999999'
    											 ,@SMS_SND_YN = 'N' -- 알림톡 실패시 SMS 전송 여부
    											 ,@TR_TYPE_CD = 'B' -- R: 실시간발송 B:예약발송
    											 ,@RES_CODE = ''
    											 ,@CUS_NO = @CUS_NO_cur
    											 ,@AGT_CODE = NULL
    											 ,@EMP_SEQ = NULL
    											 ,@CUS_NAME = ''
												 ,@ATTACHMENT='{																	"button": [
																		{
																			"name": "채널 추가",
																			"type": "AC"
																		}
																	]
																}'

				/* 웹링크가 있는 경우 
        
				{
					"button": [
						{
							"name": "채널 추가",
							"type": "AC"
						},
						{
							"name": "웹링크명",
							"type": "WL",
							"url_mobile": "http://m.verygoodtour.com/WebZine/WebZineView?BoardSeq=482",
							"url_pc": "http://www.verygoodtour.com/Board/BoardCommonView?MenuCode=10902"
						}
					]
				}        
         
				*/
		
	
		FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_TEL_cur
	END
	
	CLOSE my_cursor
	DEALLOCATE my_cursor
	
	
END

GO
