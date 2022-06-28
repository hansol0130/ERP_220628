USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_RES_SND_APP_INFO_INSERT
■ DESCRIPTION				: 롯데면세점 혜택 안내 - 알림톡 발송 요청 REFS #1513
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-08-10		오준혁			최초생성
   2021-10-28		오준혁			발송시점 변경(출발 10일 전, 5일 전 => 출발 21일 전, 7일 전)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_RES_SND_LOTTE_INFO_INSERT]
AS 
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	/*
	 *
		1. 발송 대상: Pro_type == 1, SIGN_CODE != K 1 Z
		2. 발송 시점: 출발 10일 전, 5일 전 => 출발 21일 전, 7일 전  (2회 발송)	
		3. 템플릿 : SYS_AT_0163 (버튼형)
		-- 2021년 12월 31일 출발자까지
		
		[참좋은여행]

		#{NAME}님,
		여행 출발까지 #{일자}일 남았습니다.

		● 상품명: #{상품명}
		● 예약번호: #{예약번호}

		위 상품으로 여행하시는 고객님께만 드리는
		롯데면세점 혜택 알려드립니다.

		여행을 더욱 즐겁고 알차게 준비하세요.

		감사합니다.

		
	 * 
	 */	
	
	
	
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD        VARCHAR(20) = 'SYS_AT_0163'	-- 사용 템플릿 번호
	       ,@CONTS_TXT      VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       ,@REQ_DTM        VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMdd090000') -- 알림톡 발송일시 (금일 오전 9시로 예약)

	SELECT @CONTS_TXT_TEMP = CONTS_TXT
	FROM   SEND.dbo.NVMOBILECONTENTS
	WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	
	       
	/*
	 * 대상자 알림톡 발송
	 */
	
	DECLARE @DEP_DATE_10     DATE = DATEADD(DD, 10, GETDATE()) -- 출발일 10일전
	       ,@DEP_DATE_5      DATE = DATEADD(DD, 5, GETDATE()) -- 출발일 5일전

	DECLARE @DEP_DATE_21     DATE = DATEADD(DD, 21, GETDATE()) -- 출발일 21일전
	       ,@DEP_DATE_7      DATE = DATEADD(DD, 7, GETDATE()) -- 출발일 7일전

	-- 커서 변수
	DECLARE @CUS_NO_cur       INT
		   ,@CUS_NAME_cur     VARCHAR(40)
		   ,@CUS_TEL_cur      VARCHAR(11)
		   ,@PRO_NAME_cur     VARCHAR(100)
		   ,@RES_CODE_cur     VARCHAR(12) 
	
	
	/*
	 * 1. 21 일차 출발자 알림톡 발송 
	 */
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT b.CUS_NO
	      ,b.CUS_NAME
		  ,b.NOR_TEL1 + b.NOR_TEL2 + b.NOR_TEL3 AS 'CUS_TEL'
	      ,c.PRO_NAME
	      ,a.RES_CODE
	FROM   RES_MASTER_damo a
	       INNER LOOP JOIN RES_CUSTOMER_damo b
	            ON  a.RES_CODE = b.RES_CODE
	       INNER JOIN PKG_DETAIL c
	            ON  c.PRO_CODE = a.PRO_CODE
	       INNER JOIN PKG_MASTER d
				ON d.MASTER_CODE = c.MASTER_CODE
	WHERE  a.PRO_TYPE = 1
		   AND d.SIGN_CODE NOT IN ('K','1','Z') -- 국내, 마켓(1, Z)
	       AND a.DEP_DATE >= @DEP_DATE_21
	       AND a.DEP_DATE < DATEADD(DD ,1 ,@DEP_DATE_21)
	       AND a.RES_STATE < 7
	       AND b.RES_STATE = 0
	       AND ISNULL(b.NOR_TEL1 ,'') = '010'
	       AND LEN(ISNULL(b.NOR_TEL2 ,'')) = 4
	       AND LEN(ISNULL(b.NOR_TEL3 ,'')) = 4
	       	
	OPEN my_cursor
	
	FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_TEL_cur,
	                          @PRO_NAME_cur, @RES_CODE_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{NAME}', @CUS_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{일자}', '21')
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{상품명}', @PRO_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{예약번호}', @RES_CODE_cur)
		
		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    											 ,@PHONE_NUM= @CUS_TEL_cur
    											 ,@TMPL_CD = @TMPL_CD
    											 ,@SND_MSG = @CONTS_TXT
    											 ,@REQ_DTM = @REQ_DTM
    											 ,@SUBJECT = '롯데면세점_히든페이지'
    											 ,@SMS_SND_NUM = '0221884000'
    											 ,@REQ_DEPT_CD = '529'
    											 ,@REQ_USR_ID = '9999999'
    											 ,@SMS_SND_YN = 'N'
    											 ,@TR_TYPE_CD = 'B' -- R: 실시간발송 B:예약발송
    											 ,@RES_CODE = NULL
    											 ,@CUS_NO = @CUS_NO_cur
    											 ,@AGT_CODE = NULL
    											 ,@EMP_SEQ = NULL
    											 ,@CUS_NAME = @CUS_NAME_cur
												 ,@ATTACHMENT = '{"button" : [{"name" : "채널추가","type" : "AC" },{ "name" : "면세 혜택 바로가기", "type" : "WL", "url_mobile" : "https://m.kor.lottedfs.com/kr/event/eventDetail?evtDispNo=1038173", "url_pc" : "https://kor.lottedfs.com/kr/event/eventDetail?evtDispNo=1038173" } ]}'	
		
		
		-- 알림톡 발송 로그
		INSERT INTO onetime.LOTTE_INFO_LOG
		(
			RES_CODE,
			TEL
		)
		VALUES
		(
			@RES_CODE_cur,
			@CUS_TEL_cur
		)

		FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_TEL_cur,
		                          @PRO_NAME_cur, @RES_CODE_cur
	END
	
	CLOSE my_cursor
	DEALLOCATE my_cursor
	
	

	
	/*
	 * 1. 7 일차 출발자 알림톡 발송 
	 */
	DECLARE my_cursor2 CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT b.CUS_NO
	      ,b.CUS_NAME
		  ,b.NOR_TEL1 + b.NOR_TEL2 + b.NOR_TEL3 AS 'CUS_TEL'
	      ,c.PRO_NAME
	      ,a.RES_CODE
	FROM   RES_MASTER_damo a
	       INNER LOOP JOIN RES_CUSTOMER_damo b
	            ON  a.RES_CODE = b.RES_CODE
	       INNER JOIN PKG_DETAIL c
	            ON  c.PRO_CODE = a.PRO_CODE
	       INNER JOIN PKG_MASTER d
				ON d.MASTER_CODE = c.MASTER_CODE
	WHERE  a.PRO_TYPE = 1
		   AND d.SIGN_CODE NOT IN ('K','1','Z') -- 국내, 마켓(1, Z)
	       AND a.DEP_DATE >= @DEP_DATE_7
	       AND a.DEP_DATE < DATEADD(DD ,1 ,@DEP_DATE_7)
	       AND a.RES_STATE < 7
	       AND b.RES_STATE = 0
	       AND ISNULL(b.NOR_TEL1 ,'') = '010'
	       AND LEN(ISNULL(b.NOR_TEL2 ,'')) = 4
	       AND LEN(ISNULL(b.NOR_TEL3 ,'')) = 4
	       	
	OPEN my_cursor2
	
	FETCH FROM my_cursor2 INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_TEL_cur,
	                          @PRO_NAME_cur, @RES_CODE_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{NAME}', @CUS_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{일자}', '7')
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{상품명}', @PRO_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{예약번호}', @RES_CODE_cur)

		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    											 ,@PHONE_NUM= @CUS_TEL_cur
    											 ,@TMPL_CD = @TMPL_CD
    											 ,@SND_MSG = @CONTS_TXT
    											 ,@REQ_DTM = @REQ_DTM
    											 ,@SUBJECT = '롯데면세점_히든페이지'
    											 ,@SMS_SND_NUM = '0221884000'
    											 ,@REQ_DEPT_CD = '529'
    											 ,@REQ_USR_ID = '9999999'
    											 ,@SMS_SND_YN = 'N'
    											 ,@TR_TYPE_CD = 'B' -- R: 실시간발송 B:예약발송
    											 ,@RES_CODE = NULL
    											 ,@CUS_NO = @CUS_NO_cur
    											 ,@AGT_CODE = NULL
    											 ,@EMP_SEQ = NULL
    											 ,@CUS_NAME = @CUS_NAME_cur
												 ,@ATTACHMENT = '{"button" : [{"name" : "채널추가","type" : "AC" },{ "name" : "면세 혜택 바로가기", "type" : "WL", "url_mobile" : "https://m.kor.lottedfs.com/kr/event/eventDetail?evtDispNo=1038173", "url_pc" : "https://kor.lottedfs.com/kr/event/eventDetail?evtDispNo=1038173" } ]}'	
		
		
		-- 알림톡 발송 로그
		INSERT INTO onetime.LOTTE_INFO_LOG
		(
			RES_CODE,
			TEL
		)
		VALUES
		(
			@RES_CODE_cur,
			@CUS_TEL_cur
		)
	
	
		FETCH FROM my_cursor2 INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_TEL_cur,
		                          @PRO_NAME_cur, @RES_CODE_cur
	END
	
	CLOSE my_cursor2
	DEALLOCATE my_cursor2
	

END

GO
