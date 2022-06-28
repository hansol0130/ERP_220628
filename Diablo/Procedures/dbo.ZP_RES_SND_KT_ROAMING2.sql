USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: ZP_RES_SND_KT_ROAMING2
■ DESCRIPTION				: KT로밍에그 난수번호 알림톡 발송의 건 REFS #1544
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 


■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2021-09-24		오준혁			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_RES_SND_KT_ROAMING2]
AS 
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
	/*
	 *
		1. 발송 대상: 올해 12/31 내로 두바이 상품 출발 하는 고객 (EPP2210, EPP2211)
		             - 로밍에그 쿠폰번호는 대표 예약자에게 발송됩니다.
		2. 발송 시점: 출발 3일 전
		3. 템플릿 : SYS_AT_0161	
		
		--------------------------------------------------	
        #{NAME} : 고객명
        #{난수코드} : (기존에 전달했던 1천개 난수코드 그대로이며 미사용분부터 발송 요청드립니다.)
        #{유효기간} : 2021년 12월 31일까지
        #{로밍센터위치} : 인천공항 1 터미널 (3F 체크인 카운터 F, 1F 출구 10~11), 인천공항 2 터미널 (3F 체크인 카운터 D/E, 1F 출구 2~3)
        
		난수코드는 1팀 당 1개씩입니다. (1팀 3인 기준)
		예약코드 당 구성인원이 1~3일 경우 예약자에게 1개 쿠폰번호 발송
							4~6일 경우 예약자에게 2개 쿠폰번호 발송
							7~9일 경우 예약자에게 3개 쿠폰번호 발송 ...	
		--------------------------------------------------
		
		
		[참좋은여행]
		#{NAME}님, 여행 출발까지 3일 남았습니다.

		아래 발급된 로밍에그 쿠폰번호를 확인해주세요.

		● 쿠폰번호: #{난수코드}
		● 유효기간: #{유효기간}
		● 이용 방법: 로밍에그 예약 후, 공항에서 로밍에그 수령 시 쿠폰번호가 포함된 해당 알림톡을 제시하시면 1일 무료 추가 적용
		● 공항로밍센터 위치: #{로밍센터위치}

		* 로밍에그 쿠폰번호는 대표 예약자에게 발송됩니다.

		감사합니다.

		
	 * 
	 */	
	
	
	
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD       VARCHAR(20) = 'SYS_AT_0161'	-- 사용 템플릿 번호
	       ,@CONTS_TXT     VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       ,@REQ_DTM       VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMdd110000') -- 알림톡 발송일시 (금일 오전 9시로 예약)

	SELECT @CONTS_TXT_TEMP = CONTS_TXT
	FROM   SEND.dbo.NVMOBILECONTENTS
	WHERE KAKAO_TMPL_CD = @TMPL_CD
	
	
	       
	/*
	 * 알림톡 대상자
	 */
	DECLARE @RES_CODE_cur     CHAR(12)
	       ,@CUS_NO_cur       INT
	       ,@CUS_NAME_cur     VARCHAR(40)
	       ,@CUS_TEL_cur      VARCHAR(11)
	       ,@CODE_CNT_cur     INT
	       
	       ,@COUPON_CODE      VARCHAR(100)
	
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT a.RES_CODE
		  ,MAX(a.CUS_NO) AS 'CUS_NO'
	      ,MAX(a.RES_NAME) AS 'CUS_NAME'
	      ,MAX(a.NOR_TEL1) + MAX(a.NOR_TEL2) + MAX(a.NOR_TEL3) AS 'CUS_TEL'
	      ,(COUNT(1) / 3) + IIF(COUNT(1) % 3 = 0, 0, 1) AS 'CODE_CNT'
	FROM   RES_MASTER_damo a
	       INNER LOOP JOIN RES_CUSTOMER_damo b
	            ON  a.RES_CODE = b.RES_CODE
	WHERE a.MASTER_CODE IN ('EPP2210', 'EPP2211')
	AND a.RES_STATE < 7
	AND b.RES_STATE = 0
	AND a.DEP_DATE = DATEADD(DAY, 3, (CAST(GETDATE() AS DATE))) AND a.DEP_DATE <= '2021-12-31'
	AND ISNULL(a.NOR_TEL1 ,'') = '010'
	AND LEN(ISNULL(a.NOR_TEL2 ,'')) = 4
	AND LEN(ISNULL(a.NOR_TEL3 ,'')) = 4
	GROUP BY a.RES_CODE
	ORDER BY (COUNT(1) / 3) + IIF(COUNT(1) % 3 = 0, 0, 1)
	
	OPEN my_cursor

	FETCH FROM my_cursor INTO @RES_CODE_cur, @CUS_NO_cur, @CUS_NAME_cur,
	                          @CUS_TEL_cur, @CODE_CNT_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		-- 쿠폰용 코드를 가져온다.
		SELECT @COUPON_CODE = STUFF(
		           (
		               SELECT TOP(@CODE_CNT_cur) ', ' + code
		               FROM   onetime.KT_ROAMING_CODE
		               WHERE  USE_YN = 'N' FOR XML PATH('')
		           )
		          ,1
		          ,2
		          ,''
		)
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{NAME}', @CUS_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{난수코드}', @COUPON_CODE)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{유효기간}', '2021년 12월 31일까지')
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{로밍센터위치}', '인천공항 1 터미널 (3F 체크인 카운터 F, 1F 출구 10~11), 인천공항 2 터미널 (3F 체크인 카운터 D/E, 1F 출구 2~3)')
		 
		-- 알림톡 발송
		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    											 ,@PHONE_NUM= @CUS_TEL_cur
    											 ,@TMPL_CD = @TMPL_CD
    											 ,@SND_MSG = @CONTS_TXT
    											 ,@REQ_DTM = @REQ_DTM
    											 ,@SUBJECT = 'KT로밍에그_쿠폰번호'
    											 ,@SMS_SND_NUM = '0221884000'
    											 ,@REQ_DEPT_CD = '529'
    											 ,@REQ_USR_ID = '9999999'
    											 ,@SMS_SND_YN = 'N'
    											 ,@TR_TYPE_CD = 'B' -- R: 실시간발송 B:예약발송
    											 ,@RES_CODE = @RES_CODE_cur
    											 ,@CUS_NO = @CUS_NO_cur
    											 ,@AGT_CODE = NULL
    											 ,@EMP_SEQ = NULL
    											 ,@CUS_NAME = @CUS_NAME_cur
												 ,@ATTACHMENT='{"button" : [{ "name" : "로밍에그 예약하기", "type" : "WL", "url_mobile" : "https://kt.com/n7q9", "url_pc" : "https://kt.com/t6fb" } ]}'	

		-- 쿠폰 사용 업데이트
		UPDATE onetime.KT_ROAMING_CODE
		SET    USE_YN = 'Y'
		WHERE  CODE IN (SELECT TOP(@CODE_CNT_cur) CODE
						FROM   onetime.KT_ROAMING_CODE
						WHERE  USE_YN = 'N')
		
		
		-- 알림톡 발송 후 로그 저장
		INSERT INTO onetime.KT_ROAMING_CODE_LOG
		(
			RES_CODE,
			CUS_NO,
			CONTS_TXT,
			CODE
		)
		VALUES
		(
			@RES_CODE_cur,
			@CUS_NO_cur,
			@CONTS_TXT,
			@COUPON_CODE
		)
		
		
	
		FETCH FROM my_cursor INTO @RES_CODE_cur, @CUS_NO_cur, @CUS_NAME_cur,
	                              @CUS_TEL_cur, @CODE_CNT_cur
	END
	
	CLOSE my_cursor
	DEALLOCATE my_cursor
	
	
END

GO
