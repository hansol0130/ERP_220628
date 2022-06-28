USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_ERP_HOTEL_SEND_RESERVE_ALIMTALK
■ DESCRIPTION					: 홈쇼핑호텔_예약일림톡_발송
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    :

exec ZP_DHS_ERP_HOTEL_SEND_RESERVE_ALIMTALK 'XPP1112', 'RP2201127227,RP2201127228'

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-21		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_ERP_HOTEL_SEND_RESERVE_ALIMTALK]
		@MASTER_CODE       VARCHAR(10)
       ,@RES_CODE_LIST     VARCHAR(1000)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	
	/*
	 *
		1. 발송 대상: 
		2. 발송 시점: 실시간	
		3. 템플릿 : SYS_AT_0184
		
		
		[참좋은여행]
		#{마스터명} 숙박권 예약안내 
		#{마스터명} #{행사명} 상품을 이용해 주셔서 감사합니다.

		숙박권 정보의 예약하기 링크를 통해 원하시는 날짜를 선택하여 예약을 완료해 주세요. 
		[※ 예약은 선착순으로 진행되며, 날짜별로 객실수량이 한정적으로 예약이 조기 마감될 수 있습니다.]

		[숙박권 정보]
		● 주문자명 : #{NAME} 
		● 주문번호 : #{예약번호} 
		● 예약하기 : #{예약URL}

		[문의정보]
		● 판매자 : 참좋은여행㈜
		● 상담전화 : #{담당자전화번호}

		[결제취소 및 반품안내]
		※ 본 상품은 카카오톡(알림톡) 또는 문자메시지로만 상품정보가 전송되며, 다른 방식으로 전달되지 않습니다. 
		※ 본 상품은 상품설명에 명시된 이용기간에 사용하지 않을 경우 이용권한이 소멸됩니다.
		※ 본 상품은 특정일자 또는 추가서비스등 으로 추가비용이 발생될 수 있습니다.
		※ 예약은 선착순으로 진행되며, 객실 수량에 따라 특정날짜의 예약이 조기 마감될 수 있습니다. 
		※ 본 상품의 환불 규정은 상품 상세 페이지를 확인 바랍니다. 
		※ 날짜 변경은 유선상 요청해주셔야 하며, 1회만 변경 가능합니다.
		※ 상담 전화 #{담당자전화번호} 근무시간 09:00 ~ 18:00 (토/일/공휴일 휴무) 

		감사합니다.


		
	 * 
	 */	
	 
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD       VARCHAR(20) = 'SYS_AT_0184'	-- 사용 템플릿 번호
	       ,@CONTS_TXT     VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       ,@REQ_DTM       VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMddHHmmss') -- 알림톡 발송일시
		   ,@SHORT_URL     VARCHAR(100) = 'http://vgt.kr/u/Y4SB?C='


	SELECT @CONTS_TXT_TEMP = CONTS_TXT
	FROM   SEND.dbo.NVMOBILECONTENTS
	WHERE KAKAO_TMPL_CD = @TMPL_CD

	 	
	-- 발송대상 임시 테이블 생성
	CREATE TABLE dbo.#AlimTalk (
		MASTER_NAME VARCHAR(100)
		,PRO_NAME VARCHAR(100)
		,RES_NAME VARCHAR(40)
		,RES_CODE CHAR(12)
		,RES_LINK VARCHAR(100)
		,CUS_TEL VARCHAR(20)
	)
	
	
	-- 리스트 생성
	IF @RES_CODE_LIST = '' --예약알림톡 발송이력이 없는 모든 예약건
	BEGIN
		
		INSERT INTO dbo.#AlimTalk
		  (
		    MASTER_NAME
		   ,PRO_NAME
		   ,RES_NAME
		   ,RES_CODE
		   ,RES_LINK
		   ,CUS_TEL
		  )
		SELECT c.MASTER_NAME
		      ,a.PRO_NAME
		      ,a.RES_NAME
		      ,a.RES_CODE
		      ,@SHORT_URL + dbo.XN_RES_CODE_CHANGE(a.RES_CODE) AS 'RES_LINK'
		      ,a.NOR_TEL1 + a.NOR_TEL2 + a.NOR_TEL3 AS 'CUS_TEL'
		FROM   dbo.RES_MASTER_damo a
		       INNER JOIN dbo.RES_DHS_DETAIL b
		            ON  b.RES_CODE = a.RES_CODE
		       INNER JOIN dbo.PKG_MASTER c
		            ON  c.MASTER_CODE = a.MASTER_CODE
		WHERE  a.MASTER_CODE = @MASTER_CODE
		       AND ISNULL(a.NOR_TEL1,'') <> ''
		       AND b.RES_TALK_SEND IS NULL
		
	END
	ELSE
	BEGIN
		
		INSERT INTO dbo.#AlimTalk
		  (
		    MASTER_NAME
		   ,PRO_NAME
		   ,RES_NAME
		   ,RES_CODE
		   ,RES_LINK
		   ,CUS_TEL
		  )
		SELECT c.MASTER_NAME
		      ,a.PRO_NAME
		      ,a.RES_NAME
		      ,a.RES_CODE
		      ,@SHORT_URL + dbo.XN_RES_CODE_CHANGE(a.RES_CODE) AS 'RES_LINK'
		      ,a.NOR_TEL1 + a.NOR_TEL2 + a.NOR_TEL3 AS 'CUS_TEL'
		FROM   dbo.RES_MASTER_damo a
		       INNER JOIN dbo.RES_DHS_DETAIL b
		            ON  b.RES_CODE = a.RES_CODE
		       INNER JOIN dbo.PKG_MASTER c
		            ON  c.MASTER_CODE = a.MASTER_CODE
		WHERE  a.MASTER_CODE = @MASTER_CODE
		       AND a.RES_CODE IN (
		       		SELECT DATA
		       		FROM   DBO.FN_SPLIT(@RES_CODE_LIST ,',')
		       )
		       AND ISNULL(a.NOR_TEL1,'') <> ''
		       		
	END

	--SELECT * FROM dbo.#AlimTalk
	
	DECLARE @MASTER_NAME_cur     VARCHAR(100)
	       ,@PRO_NAME_cur        VARCHAR(100)
	       ,@RES_NAME_cur        VARCHAR(40)
	       ,@RES_CODE_cur        CHAR(12)
	       ,@RES_LINK_cur        VARCHAR(100)
	       ,@CUS_TEL_cur         VARCHAR(20) 
	
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT MASTER_NAME
	      ,PRO_NAME
	      ,RES_NAME
	      ,RES_CODE
	      ,RES_LINK
	      ,CUS_TEL
	FROM   dbo.#AlimTalk
	
	OPEN my_cursor
	
	FETCH FROM my_cursor INTO @MASTER_NAME_cur, @PRO_NAME_cur, @RES_NAME_cur,
	                          @RES_CODE_cur, @RES_LINK_cur, @CUS_TEL_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{마스터명}', @MASTER_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{행사명}', @PRO_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{NAME}', @RES_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{예약번호}', @RES_CODE_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{예약URL}', @RES_LINK_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{담당자전화번호}', '02-2188-4080')
		
		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    											 ,@PHONE_NUM= @CUS_TEL_cur
    											 ,@TMPL_CD = @TMPL_CD
    											 ,@SND_MSG = @CONTS_TXT
    											 ,@REQ_DTM = @REQ_DTM
    											 ,@SUBJECT = '홈쇼핑호텔_예약안내'
    											 ,@SMS_SND_NUM = '0221884080' -- 국내팀 대표번호
    											 ,@REQ_DEPT_CD = '509' -- 국내파트
    											 ,@REQ_USR_ID = '9999999'
    											 ,@SMS_SND_YN = 'Y' -- 실패시 SMS 전송(Y)
    											 ,@TR_TYPE_CD = 'R' -- R: 실시간발송 B:예약발송
    											 ,@RES_CODE = @RES_CODE_cur
    											 ,@CUS_NO = NULL
    											 ,@AGT_CODE = NULL
    											 ,@EMP_SEQ = NULL
    											 ,@CUS_NAME = @RES_NAME_cur
		
	
		-- 발송된 알림톡 로그 저장
		UPDATE dbo.RES_DHS_DETAIL
		SET    RES_TALK_SEND = GETDATE()
		WHERE  RES_CODE = @RES_CODE_cur
		
		
		-- 상태값 변경 (확인중:1)
		UPDATE dbo.RES_MASTER_damo
		SET    RES_STATE = 1
		WHERE  RES_CODE = @RES_CODE_cur
		
	
		FETCH FROM my_cursor INTO @MASTER_NAME_cur, @PRO_NAME_cur, @RES_NAME_cur, 
								  @RES_CODE_cur, @RES_LINK_cur, @CUS_TEL_cur
	END
	
	CLOSE my_cursor
	DEALLOCATE my_cursor
	
	
END
GO
