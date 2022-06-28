USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: ZP_RES_SND_LOTTE_INFO_V3_INSERT
■ DESCRIPTION				: 알림톡 템플릿 신규 등록 및 발송 요청 REFS #1749
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2022-01-12		김홍우			템플릿 변경(SYS_AT_0183)
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_RES_SND_LOTTE_INFO_V3_INSERT]
AS 
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	/*
	 *
		1. 발송 대상: Pro_type == 1 (패키지), SIGN_CODE != K 1 Z (해외)
		1. 발송 대상: SIGN_CODE != K 1 Z (해외)
		2. 발송 시점: 출발 7일 전, 1일 전  (2회 발송)	
		3. 템플릿 : SYS_AT_0183 
		4. 발송 기간 : ~ 22/12/31
		
		[참좋은여행]

		#{NAME}님, 안녕하세요.
		여행 출발까지 #{일자}일 남았습니다.

		참좋은여행 고객님께만 드리는
		롯데면세점 인천공항점(제2터미널) 할인쿠폰입니다.

		인천공항점에 방문하시어
		본 메시지를 제시하시면 아래 혜택을 받으실 수 있습니다.

		● 롯데면세점 인천공항점 할인 혜택
		- $100이상 구매시 5천원 할인 - 810211418601
		- $200이상 구매시 1만원 할인 - 810211418617
		- $500이상 구매시 3만원 할인 - 810211418625

		여행을 더욱 즐겁고 알차게 준비하세요.

		<할인쿠폰 유의사항>
		1. 당일 1인 1매 사용 가능 (같은 매장 내 상품 합산 가능)
		2. 타 할인쿠폰 및 30%이상 할인상품 중복적용 불가
		3. 담배 등 일부 브랜드 제외
		4. VIP할인 및 LDF PAY 증정 중복 가능
		5. 당사 사정에 따라 변경 및 사용 제한 가능

		
	 * 
	 */	
	
	
	
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD        VARCHAR(20) = 'SYS_AT_0183'	-- 사용 템플릿 번호
	       ,@CONTS_TXT      VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       ,@REQ_DTM        VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMdd090000') -- 알림톡 발송일시 (금일 오전 9시로 예약)

	SELECT @CONTS_TXT_TEMP = CONTS_TXT
	FROM   SEND.dbo.NVMOBILECONTENTS
	WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	
	       
	/*
	 * 대상자 알림톡 발송
	 */

	DECLARE @DEP_DATE_7     DATE = DATEADD(DD, 7, GETDATE()) -- 출발일 7일전
	       ,@DEP_DATE_1      DATE = DATEADD(DD, 1, GETDATE()) -- 출발일 1일전

	-- 커서 변수
	DECLARE @CUS_NO_cur       INT
		   ,@CUS_NAME_cur     VARCHAR(40)
		   ,@CUS_TEL_cur      VARCHAR(11)
		   ,@PRO_NAME_cur     VARCHAR(100)
		   ,@RES_CODE_cur     VARCHAR(12) 
	
	
	/*
	 * 1. 7 일차 출발자 알림톡 발송 
	 */
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR

    SELECT b.CUS_NO
          ,b.CUS_NAME
          ,b.NOR_TEL1+b.NOR_TEL2+b.NOR_TEL3 AS 'CUS_TEL'
          ,c.PRO_NAME
          ,a.RES_CODE
    FROM   RES_MASTER_damo a
           INNER LOOP
           JOIN RES_CUSTOMER_damo b
                ON  a.RES_CODE = b.RES_CODE
           INNER JOIN PKG_DETAIL c
                ON  c.PRO_CODE = a.PRO_CODE
           INNER JOIN PKG_MASTER d
                ON  d.MASTER_CODE = c.MASTER_CODE
           INNER JOIN PRO_TRANS_SEAT e
                ON  c.SEAT_CODE = e.SEAT_CODE
    WHERE  a.pro_type IN (1 ,4) --패키지, 자유
           AND d.SIGN_CODE NOT IN ('K' ,'1' ,'Z') -- 국내, 마켓(1, Z)
           AND a.DEP_DATE >= @DEP_DATE_7
           AND a.DEP_DATE<DATEADD(DD ,1 ,@DEP_DATE_7)
           AND a.RES_STATE<7
           AND b.RES_STATE = 0
           AND ISNULL(b.NOR_TEL1 ,'') = '010'
           AND LEN(ISNULL(b.NOR_TEL2 ,'')) = 4
           AND LEN(ISNULL(b.NOR_TEL3 ,'')) = 4
           AND e.DEP_TRANS_CODE IN ('KE'
                                   ,'DL'
                                   ,'AF'
                                   ,'KL'
                                   ,'AM'
                                   ,'AZ'
                                   ,'CI'
                                   ,'OK'
                                   ,'MF'
                                   ,'SU'
                                   ,'GA')
                                             
	       	
	OPEN my_cursor
	
	FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_TEL_cur,
	                          @PRO_NAME_cur, @RES_CODE_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{NAME}', @CUS_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{일자}', '7')
		--SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{단일난수}', 'VERYGOOD2022')
		
		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
		    ,@PHONE_NUM=@CUS_TEL_cur
		    ,@TMPL_CD=@TMPL_CD
		    ,@SND_MSG=@CONTS_TXT
		    ,@REQ_DTM=@REQ_DTM
		    ,@SUBJECT='롯데면세점 T2 혜택'
		    ,@SMS_SND_NUM='0221884000'
		    ,@REQ_DEPT_CD='529'
		    ,@REQ_USR_ID='9999999'
		    ,@SMS_SND_YN='N'
		    ,@TR_TYPE_CD='B' -- R: 실시간발송 B:예약발송
		    ,@RES_CODE=NULL
		    ,@CUS_NO=@CUS_NO_cur
		    ,@AGT_CODE=NULL
		    ,@EMP_SEQ=NULL
		    ,@CUS_NAME=@CUS_NAME_cur
		    ,@ATTACHMENT='{"button" : [{"name" : "주류 온라인 예약하기","type" : "WL", "url_mobile" : "https://m.kor.lottedfs.com/kr/ebtqmain/service#alcrsv", "url_pc" : "https://kor.lottedfs.com/kr/ebtqmain/intro#alcrsv" },{ "name" : "매장 위치 안내", "type" : "WL", "url_mobile" : "https://kr.lottedfs.com/business/branch-korea/detail.do?detailsKey=147", "url_pc" : "https://kr.lottedfs.com/business/branch-korea/detail.do?detailsKey=147" } ]}' 
		
		
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
	 * 2. 1 일차 출발자 알림톡 발송 
	 */
	DECLARE my_cursor2 CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT b.CUS_NO
          ,b.CUS_NAME
          ,b.NOR_TEL1+b.NOR_TEL2+b.NOR_TEL3 AS 'CUS_TEL'
          ,c.PRO_NAME
          ,a.RES_CODE
    FROM   RES_MASTER_damo a
           INNER LOOP
           JOIN RES_CUSTOMER_damo b
                ON  a.RES_CODE = b.RES_CODE
           INNER JOIN PKG_DETAIL c
                ON  c.PRO_CODE = a.PRO_CODE
           INNER JOIN PKG_MASTER d
                ON  d.MASTER_CODE = c.MASTER_CODE
           INNER JOIN PRO_TRANS_SEAT e
                ON  c.SEAT_CODE = e.SEAT_CODE
    WHERE  a.pro_type IN (1 ,4) --패키지, 자유
           AND d.SIGN_CODE NOT IN ('K' ,'1' ,'Z') -- 국내, 마켓(1, Z)
           AND a.DEP_DATE >= @DEP_DATE_1
           AND a.DEP_DATE<DATEADD(DD ,1 ,@DEP_DATE_1)
           AND a.RES_STATE<7
           AND b.RES_STATE = 0
           AND ISNULL(b.NOR_TEL1 ,'') = '010'
           AND LEN(ISNULL(b.NOR_TEL2 ,'')) = 4
           AND LEN(ISNULL(b.NOR_TEL3 ,'')) = 4
           AND e.DEP_TRANS_CODE IN ('KE'
                                   ,'DL'
                                   ,'AF'
                                   ,'KL'
                                   ,'AM'
                                   ,'AZ'
                                   ,'CI'
                                   ,'OK'
                                   ,'MF'
                                   ,'SU'
                                   ,'GA')
	       	
	OPEN my_cursor2
	
	FETCH FROM my_cursor2 INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_TEL_cur,
	                          @PRO_NAME_cur, @RES_CODE_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{NAME}', @CUS_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{일자}', '1')
		--SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{단일난수}', 'VERYGOOD2022')

		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
		    ,@PHONE_NUM=@CUS_TEL_cur
		    ,@TMPL_CD=@TMPL_CD
		    ,@SND_MSG=@CONTS_TXT
		    ,@REQ_DTM=@REQ_DTM
		    ,@SUBJECT='롯데면세점 T2 혜택'
		    ,@SMS_SND_NUM='0221884000'
		    ,@REQ_DEPT_CD='529'
		    ,@REQ_USR_ID='9999999'
		    ,@SMS_SND_YN='N'
		    ,@TR_TYPE_CD='B' -- R: 실시간발송 B:예약발송
		    ,@RES_CODE=NULL
		    ,@CUS_NO=@CUS_NO_cur
		    ,@AGT_CODE=NULL
		    ,@EMP_SEQ=NULL
		    ,@CUS_NAME=@CUS_NAME_cur
		    ,@ATTACHMENT='{"button" : [{"name" : "주류 온라인 예약하기","type" : "WL", "url_mobile" : "https://m.kor.lottedfs.com/kr/ebtqmain/service#alcrsv", "url_pc" : "https://kor.lottedfs.com/kr/ebtqmain/intro#alcrsv" },{ "name" : "매장 위치 안내", "type" : "WL", "url_mobile" : "https://kr.lottedfs.com/business/branch-korea/detail.do?detailsKey=147", "url_pc" : "https://kr.lottedfs.com/business/branch-korea/detail.do?detailsKey=147" } ]}' 
		
		
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
