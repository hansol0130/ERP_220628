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
   2021-11-09		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [onetime].[ZP_CUS_SND_TVCF]
AS 
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	/*
	 *
		1. 발송 대상: onetime.EVT_RE_TOGETHER 테일블에 있는 명단 (약 60만명)
		2. 발송 시점: 2021-11-11 (10만명씩 1시간마다 전송)
		3. 템플릿 : SYS_AT_0166 	
		
		--------------------------------------------------	
			#{회원등급} : VIP(그린)
			#{상세페이지 URL} : http://vgt.kr/u/XnUF  => 다시, 함께 캠페인 페이지
		--------------------------------------------------
		
			[참좋은여행]

			장기간 여행 제한으로 
			2022년 VIP 등급 선정 기준이 한시적으로 완화됨에 따라
			고객님께서는 #{회원등급} 등급 대상이 되셨습니다.


			자세한 사항은 아래 URL을 통해 확인 가능합니다.

			● 자세히 보기 : #{상세페이지 URL}


			다시 여행을 시작할 수 있도록
			참좋은여행이 함께 합니다.

			다시, 함께
			참좋은여행




			-- 99806 : 예약 발송시간 09:15
			SELECT COUNT(1)
			FROM   onetime.EVT_RE_TOGETHER a
			WHERE a.IDX > 0 AND a.IDX <= 100000
			AND a.NOR_TEL1 = '010'

			-- 96937 : 예약 발송시간 10:30
			SELECT COUNT(1)
			FROM   onetime.EVT_RE_TOGETHER a
			WHERE a.IDX > 100000 AND a.IDX <= 200000
			AND a.NOR_TEL1 = '010'

			-- 96140 : 예약 발송시간 11:40
			SELECT COUNT(1)
			FROM   onetime.EVT_RE_TOGETHER a
			WHERE a.IDX > 200000 AND a.IDX <= 300000
			AND a.NOR_TEL1 = '010'


			-- 95845 : 예약 발송시간 12:50
			SELECT COUNT(1)
			FROM   onetime.EVT_RE_TOGETHER a
			WHERE a.IDX > 300000 AND a.IDX <= 400000
			AND a.NOR_TEL1 = '010'
	
			-- 95839 : 예약 발송시간 14:00 
			SELECT COUNT(1)
			FROM   onetime.EVT_RE_TOGETHER a
			WHERE a.IDX > 400000 AND a.IDX <= 500000
			AND a.NOR_TEL1 = '010'	

			-- 92644 : 예약 발송시간 15:10
			SELECT COUNT(1)
			FROM   onetime.EVT_RE_TOGETHER a
			WHERE a.IDX > 500000 AND a.IDX <= 600000
			AND a.NOR_TEL1 = '010'


		
	 * 
	 */	
	
	
	
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD       VARCHAR(20) = 'SYS_AT_0166'	-- 사용 템플릿 번호
	       ,@CONTS_TXT     VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       ,@REQ_DTM       VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMdd151000') -- 알림톡 발송일시 (금일 오전 9시로 예약)

	SELECT @CONTS_TXT_TEMP = CONTS_TXT
	FROM   SEND.dbo.NVMOBILECONTENTS
	WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	
	       
	/*
	 * 알림톡 대상자
	 */
	DECLARE @CUS_NO_cur       INT
	       ,@CUS_NAME_cur     VARCHAR(40)
	       ,@CUS_TEL_cur      VARCHAR(11)


	       
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT a.CUS_NO AS 'CUS_NO'
	      ,a.CUS_NAME AS 'CUS_NAME'
	      ,a.NOR_TEL AS 'CUS_TEL'
	FROM   onetime.EVT_RE_TOGETHER a
	WHERE a.IDX > 500000 AND a.IDX <= 600000
	AND a.NOR_TEL1 = '010'
	
	
	OPEN my_cursor

	FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_TEL_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{회원등급}', 'VIP(그린)')
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{상세페이지 URL}', 'http://vgt.kr/u/XnUF')
		 
		-- 알림톡 발송
		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    											 ,@PHONE_NUM= @CUS_TEL_cur
    											 ,@TMPL_CD = @TMPL_CD
    											 ,@SND_MSG = @CONTS_TXT
    											 ,@REQ_DTM = @REQ_DTM
    											 ,@SUBJECT = '2022년 VIP 등급 선정 기준 변경 안내'
    											 ,@SMS_SND_NUM = '0221884000'
    											 ,@REQ_DEPT_CD = '529'
    											 ,@REQ_USR_ID = '9999999'
    											 ,@SMS_SND_YN = 'N' -- 알림톡 실패시 SMS 전송 여부
    											 ,@TR_TYPE_CD = 'B' -- R: 실시간발송 B:예약발송
    											 ,@RES_CODE = ''
    											 ,@CUS_NO = @CUS_NO_cur
    											 ,@AGT_CODE = NULL
    											 ,@EMP_SEQ = NULL
    											 ,@CUS_NAME = @CUS_NAME_cur
												 ,@ATTACHMENT='{
																	"button": [
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
		
	
		FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_TEL_cur
	END
	
	CLOSE my_cursor
	DEALLOCATE my_cursor
	
	
END

GO
