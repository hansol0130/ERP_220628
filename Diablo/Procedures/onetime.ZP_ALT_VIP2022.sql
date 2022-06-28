USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: onetime.ZP_ALT_VIP2022
■ DESCRIPTION				: 2022년 VIP 선정 및 혜택 알림톡 발송의 건 #1678
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-12-13		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [onetime].[ZP_ALT_VIP2022]
	@Type VARCHAR(1)  -- P(퍼블-6), B(블루-4), G(그린-2)
AS 
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	/*
	 *
	 * 발송 요청일자 :  2021년 12월 15일(수)
	 *
	 *
	 
	  1)  퍼플등급       
             템플릿명 : VIP 퍼플등급 선정 안내(채널추가) 
             템플릿코드 : SYS_AT_0170   
             변수       
             #{년도} : 2022년     
             #{퍼플선정조건} : ① 2021년도 VIP 회원 자격 연장 적용 
             ② 최근 1년 내 1회 이상 & 직전 5년내 5회(누적 1,000만원 이상) & 최고상품가 400만원 이상 이용. 
             #{유지기간} 2022년 1월 1일 ~ 12월 31일 
             #{멤버스혜택url} : http://vgt.kr/u/WbV9 
             
             
	  2)  블루등급       
             템플릿명 : VIP 블루 선정 안내_신규 
             템플릿코드 : SYS_AT_0169   
             변수       
             #{년도} : 2022년     
             #{블루선정조건} : ① 2021년도 VIP 회원 자격 연장 적용 
             ② 최근 1년 내 1회 이상 & 직전 5년내 5회(누적 1,000만원 이상) & 
                 최고상품가 300만원 이상 이용.   
             #{유지기간} 2022년 1월 1일 ~ 12월 31일 
             #{멤버스혜택url} : http://vgt.kr/u/WbV9              
             
             
	 3)  그린등급       
             템플릿명 : VIP 퍼플등급 선정 안내(채널추가) 
             템플릿코드 : SYS_AT_0168   
             변수       
             #{년도} : 2022년     
             #{그린선정조건} : ① 2021년도 VIP 회원 자격 연장 적용 
             ② 최근 1년 내 1회 이상 & 직전 5년내 4회(누적 500만원~1,000만원 미만) & 
                 최고상품가 300만원 이상 이용.   
             ③ VIP혜택받기 이벤트 참여고객 (장기 여행제한으로 이벤트 참여고객 일시적 등급 적용) 
             #{유지기간} 2022년 1월 1일 ~ 12월 31일 
             #{멤버스혜택url} : http://vgt.kr/u/WbV9
             
                          
	 * 
	 */	
	
	--SELECT * FROM onetime.EVT_SELECT_VIP_2022
	--ORDER BY  CUS_GRADE
	
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD       VARCHAR(20) = ''	-- 사용 템플릿 번호
	       ,@CONTS_TXT     VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       ,@REQ_DTM       VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMdd103000') -- 알림톡 발송일시 (금일 오전 10시로 예약)


	/*
	 * 알림톡 대상자
	 */
	DECLARE @CUS_NO_cur       INT
	       ,@CUS_TEL_cur      VARCHAR(11)


	IF @Type = 'P' -- 퍼블
	BEGIN
		
		SET @TMPL_CD = 'SYS_AT_0170'
		
		SELECT @CONTS_TXT_TEMP = CONTS_TXT
		FROM   SEND.dbo.NVMOBILECONTENTS
		WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	       
		DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
		SELECT a.CUS_NO AS 'CUS_NO'
		      ,a.NOR_TEL AS 'CUS_TEL'
		FROM   onetime.EVT_SELECT_VIP_2022 a
		WHERE  a.CUS_GRADE = 6

	
		OPEN my_cursor

		FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_TEL_cur
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
		
			SET @CONTS_TXT = @CONTS_TXT_TEMP
		
			-- 알림톡 내용 치환
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{년도}', '2022년')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{퍼플선정조건}', '① 2021년도 VIP 회원 자격 연장 적용 ② 최근 1년 내 1회 이상 & 직전 5년내 5회(누적 1,000만원 이상) & 최고상품가 400만원 이상 이용.')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{유지기간}', '2022년 1월 1일 ~ 12월 31일')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{멤버스혜택url}', 'http://vgt.kr/u/WbV9')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{팀명}', '회원관리팀')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{팀대표번호}', '02-2185-2661')
		 
			-- 알림톡 발송
			EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    												 ,@PHONE_NUM= @CUS_TEL_cur
    												 ,@TMPL_CD = @TMPL_CD
    												 ,@SND_MSG = @CONTS_TXT
    												 ,@REQ_DTM = @REQ_DTM
    												 ,@SUBJECT = 'VIP 퍼플등급 선정 안내'
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
		
	
			FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_TEL_cur
		END
	
		CLOSE my_cursor
		DEALLOCATE my_cursor		
		
		
	END
	ELSE IF @Type = 'B' -- 블루
	BEGIN
		
		SET @TMPL_CD = 'SYS_AT_0169'
		
		SELECT @CONTS_TXT_TEMP = CONTS_TXT
		FROM   SEND.dbo.NVMOBILECONTENTS
		WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	       
		DECLARE my_cursor2 CURSOR FAST_FORWARD READ_ONLY FOR
		SELECT a.CUS_NO AS 'CUS_NO'
		      ,a.NOR_TEL AS 'CUS_TEL'
		FROM   onetime.EVT_SELECT_VIP_2022 a
		WHERE  a.CUS_GRADE = 4

	
		OPEN my_cursor2

		FETCH FROM my_cursor2 INTO @CUS_NO_cur, @CUS_TEL_cur
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
		
			SET @CONTS_TXT = @CONTS_TXT_TEMP
		
			-- 알림톡 내용 치환
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{년도}', '2022년')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{블루선정조건}', '① 2021년도 VIP 회원 자격 연장 적용 ② 최근 1년 내 1회 이상 & 직전 5년내 5회(누적 1,000만원 이상) & 최고상품가 300만원 이상 이용.')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{유지기간}', '2022년 1월 1일 ~ 12월 31일')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{멤버스혜택url}', 'http://vgt.kr/u/WbV9')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{VIP회원관리팀}', '회원관리팀')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{02-2185-2261}', '02-2185-2661')
		 
			-- 알림톡 발송
			EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    												 ,@PHONE_NUM= @CUS_TEL_cur
    												 ,@TMPL_CD = @TMPL_CD
    												 ,@SND_MSG = @CONTS_TXT
    												 ,@REQ_DTM = @REQ_DTM
    												 ,@SUBJECT = 'VIP 블루등급 선정 안내'
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
		
	
			FETCH FROM my_cursor2 INTO @CUS_NO_cur, @CUS_TEL_cur
		END
	
		CLOSE my_cursor2
		DEALLOCATE my_cursor2		
		
		
	END	
	ELSE IF @Type = 'G' -- 그린
	BEGIN
		
		SET @TMPL_CD = 'SYS_AT_0168'
		
		SELECT @CONTS_TXT_TEMP = CONTS_TXT
		FROM   SEND.dbo.NVMOBILECONTENTS
		WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	       
		DECLARE my_cursor3 CURSOR FAST_FORWARD READ_ONLY FOR
		SELECT a.CUS_NO AS 'CUS_NO'
		      ,a.NOR_TEL AS 'CUS_TEL'
		FROM   onetime.EVT_SELECT_VIP_2022 a
		WHERE  a.CUS_GRADE = 2

	
		OPEN my_cursor3

		FETCH FROM my_cursor3 INTO @CUS_NO_cur, @CUS_TEL_cur
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
		
			SET @CONTS_TXT = @CONTS_TXT_TEMP
		
			-- 알림톡 내용 치환
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{년도}', '2022년')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{그린선정조건}', '① 2021년도 VIP 회원 자격 연장 적용 ② 최근 1년 내 1회 이상 & 직전 5년내 4회(누적 500만원~1,000만원 미만) & 최고상품가 300만원 이상 이용 ③ VIP혜택받기 이벤트 참여고객 (장기 여행제한으로 이벤트 참여고객 일시적 등급 적용)')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{유지기간}', '2022년 1월 1일 ~ 12월 31일')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{멤버스혜택url}', 'http://vgt.kr/u/WbV9')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{VIP회원관리팀}', '회원관리팀')
			SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{02-2185-2261}', '02-2185-2661')
		 
			-- 알림톡 발송
			EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    												 ,@PHONE_NUM= @CUS_TEL_cur
    												 ,@TMPL_CD = @TMPL_CD
    												 ,@SND_MSG = @CONTS_TXT
    												 ,@REQ_DTM = @REQ_DTM
    												 ,@SUBJECT = 'VIP 그린등급 선정 안내'
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
		
	
			FETCH FROM my_cursor3 INTO @CUS_NO_cur, @CUS_TEL_cur
		END
	
		CLOSE my_cursor3
		DEALLOCATE my_cursor3		
		
		
	END		


	
	
END

GO
