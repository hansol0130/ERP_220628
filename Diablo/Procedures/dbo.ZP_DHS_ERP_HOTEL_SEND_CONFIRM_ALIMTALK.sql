USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_ERP_HOTEL_SEND_CONFIRM_ALIMTALK
■ DESCRIPTION					: 홈쇼핑호텔_예약확정일림톡_발송
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    :

exec ZP_DHS_ERP_HOTEL_SEND_CONFIRM_ALIMTALK 'XPP1112', 'RP2201127227,RP2201127228'

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-26		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_ERP_HOTEL_SEND_CONFIRM_ALIMTALK]
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
		3. 템플릿 : SYS_AT_0185
		
		
		[참좋은여행]

		안녕하세요 #{NAME} 고객님 
		호텔숙박권 예약이 최종 확정되었습니다.
		체크인시 아래 내용을 프론트에 제시해주세요. 

		● 호텔예약번호 : #{호텔예약번호}
		● 호텔명 : #{마스터명}
		● 룸타입 : #{행사명}
		● 체크인 : #{체크인날짜}
		● 체크아웃 : #{체크인날짜+1일}
		● 투숙객명 : #{NAME}
		● 취소규정
		#{취소규정}

		투숙일 변경 및 기타 문의사항은 고객센터로 문의바랍니다. 
		고객센터 : 참좋은여행 #{담당자연락처}


		
	 * 
	 */	
	 
	/*
	 * 알림톡 정보
	 */
	DECLARE @TMPL_CD       VARCHAR(20) = 'SYS_AT_0185'	-- 사용 템플릿 번호
	       ,@CONTS_TXT     VARCHAR(4000)
	       ,@CONTS_TXT_TEMP VARCHAR(4000)
	       ,@REQ_DTM       VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMddHHmmss') -- 알림톡 발송일시

	SELECT @CONTS_TXT_TEMP = CONTS_TXT
	FROM   SEND.dbo.NVMOBILECONTENTS
	WHERE KAKAO_TMPL_CD = @TMPL_CD

	 	
	-- 발송대상 임시 테이블 생성
	CREATE TABLE dbo.#AlimTalk (
		MASTER_NAME VARCHAR(100)
		,PRO_NAME VARCHAR(100)
		,RES_NAME VARCHAR(40)
		,RES_CODE CHAR(12)
		,CUS_TEL VARCHAR(20)
		,PKG_CONTRACT VARCHAR(MAX)
		,CFM_CODE VARCHAR(20)
		,CHECKIN_DATE VARCHAR(20)
		,CHECKOUT_DATE VARCHAR(20)
	)
	
	
	-- 리스트 생성
	IF @RES_CODE_LIST = '' --예약확정알림톡 발송이력이 없는 모든 예약건
	BEGIN
		
		INSERT INTO dbo.#AlimTalk
		  (
		    MASTER_NAME
		   ,PRO_NAME
		   ,RES_NAME
		   ,RES_CODE
		   ,CUS_TEL
		   ,PKG_CONTRACT
		   ,CFM_CODE
		   ,CHECKIN_DATE
		   ,CHECKOUT_DATE
		  )
		SELECT c.MASTER_NAME
		      ,a.PRO_NAME
		      ,a.RES_NAME
		      ,a.RES_CODE
		      ,a.NOR_TEL1 + a.NOR_TEL2 + a.NOR_TEL3 AS 'CUS_TEL'
		      ,c.PKG_CONTRACT
		      ,b.CFM_CODE
		      ,FORMAT(a.DEP_DATE, 'yyyy-MM-dd') 
		      ,FORMAT(DATEADD(DAY, 1, a.DEP_DATE), 'yyyy-MM-dd')
		FROM   dbo.RES_MASTER_damo a
		       INNER JOIN dbo.RES_DHS_DETAIL b
		            ON  b.RES_CODE = a.RES_CODE
		       INNER JOIN dbo.PKG_MASTER c
		            ON  c.MASTER_CODE = a.MASTER_CODE
		WHERE  a.MASTER_CODE = @MASTER_CODE
			   AND a.RES_STATE = 4 -- 결제완료 상태에만 보낸다.
		       AND ISNULL(a.NOR_TEL1,'') <> ''

		
	END
	ELSE
	BEGIN
		
		INSERT INTO dbo.#AlimTalk
		  (
		    MASTER_NAME
		   ,PRO_NAME
		   ,RES_NAME
		   ,RES_CODE
		   ,CUS_TEL
		   ,PKG_CONTRACT
		   ,CFM_CODE
		   ,CHECKIN_DATE
		   ,CHECKOUT_DATE
		  )
		SELECT c.MASTER_NAME
		      ,a.PRO_NAME
		      ,a.RES_NAME
		      ,a.RES_CODE
		      ,a.NOR_TEL1 + a.NOR_TEL2 + a.NOR_TEL3 AS 'CUS_TEL'
		      ,c.PKG_CONTRACT
		      ,b.CFM_CODE
		      ,FORMAT(a.DEP_DATE, 'yyyy-MM-dd') 
		      ,FORMAT(DATEADD(DAY, 1, a.DEP_DATE), 'yyyy-MM-dd')
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
		       AND a.RES_STATE = 4 -- 결제완료 상태에만 보낸다.
		       AND ISNULL(a.NOR_TEL1,'') <> ''
		       		
	END

	--SELECT * FROM dbo.#AlimTalk
	DECLARE @MASTER_NAME_cur       VARCHAR(100)
	       ,@PRO_NAME_cur          VARCHAR(100)
	       ,@RES_NAME_cur          VARCHAR(40)
	       ,@RES_CODE_cur          CHAR(12)
	       ,@CUS_TEL_cur           VARCHAR(20)
	       ,@PKG_CONTRACT_cur      VARCHAR(MAX)
	       ,@CFM_CODE_cur          VARCHAR(20)
	       ,@CHECKIN_DATE_cur      VARCHAR(20)
	       ,@CHECKOUT_DATE_cur     VARCHAR(20) 
	
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR
	SELECT MASTER_NAME
	      ,PRO_NAME
	      ,RES_NAME
	      ,RES_CODE
	      ,CUS_TEL
	      ,PKG_CONTRACT
	      ,CFM_CODE
	      ,CHECKIN_DATE
	      ,CHECKOUT_DATE
	FROM   dbo.#AlimTalk
	
	OPEN my_cursor
	
	FETCH FROM my_cursor INTO @MASTER_NAME_cur, @PRO_NAME_cur, @RES_NAME_cur,
	                          @RES_CODE_cur, @CUS_TEL_cur, @PKG_CONTRACT_cur,
	                          @CFM_CODE_cur, @CHECKIN_DATE_cur, @CHECKOUT_DATE_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @CONTS_TXT = @CONTS_TXT_TEMP
		
		-- 알림톡 내용 치환
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{NAME}', @RES_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{호텔예약번호}', @CFM_CODE_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{마스터명}', @MASTER_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{행사명}', @PRO_NAME_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{체크인날짜}', @CHECKIN_DATE_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{체크인날짜+1일}', @CHECKOUT_DATE_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{취소규정}', @PKG_CONTRACT_cur)
		SET @CONTS_TXT = REPLACE(@CONTS_TXT ,' #{담당자연락처}', '02-2188-4080')
		
		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT_BATCH @SENDER_KEY='f1e8319931392a3c30bb6fdef415f67ef87aa58c'
    											 ,@PHONE_NUM= @CUS_TEL_cur
    											 ,@TMPL_CD = @TMPL_CD
    											 ,@SND_MSG = @CONTS_TXT
    											 ,@REQ_DTM = @REQ_DTM
    											 ,@SUBJECT = '홈쇼핑호텔_예약확정'
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
		SET    CFM_TALK_SEND = GETDATE()
		WHERE  RES_CODE = @RES_CODE_cur
	
	
		-- 상태값 변경 (출발완료:5)
		UPDATE dbo.RES_MASTER_damo
		SET    RES_STATE = 5
		WHERE  RES_CODE = @RES_CODE_cur
		
			
		FETCH FROM my_cursor INTO @MASTER_NAME_cur, @PRO_NAME_cur, @RES_NAME_cur,
								  @RES_CODE_cur, @CUS_TEL_cur, @PKG_CONTRACT_cur,
								  @CFM_CODE_cur, @CHECKIN_DATE_cur, @CHECKOUT_DATE_cur
	END
	
	CLOSE my_cursor
	DEALLOCATE my_cursor
	
	
END
GO
