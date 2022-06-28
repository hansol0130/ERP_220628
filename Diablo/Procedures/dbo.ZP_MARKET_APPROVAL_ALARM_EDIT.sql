USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_APPROVAL_ALARM
■ DESCRIPTION					: 참좋은마켓 결재 알림톡 ('SYS_AT_0130')
■ INPUT PARAMETER				: 
	@RES_CODE		CHAR(12)	: 예약코드
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 신용카드, 무통장, ARS, 네이버페이 결재 시
                                  예약코드로 잔액 체크 후 결재 알림톡 1회 발송
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2021-03-16		홍종우			최초생성
   2021-06-15		홍종우			SYS_AT_0100 -> SYS_AT_0150 변경
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_APPROVAL_ALARM_EDIT]
	@RES_CODE		CHAR(12)
AS 
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @CHECK_FLAG CHAR(1)
	DECLARE @TOTAL_PRICE INT
	DECLARE @PAY_PRICE INT
	DECLARE @ATT_CODE VARCHAR(1)
	DECLARE @CUS_NAME VARCHAR(40)
	
	SELECT @TOTAL_PRICE = DBO.FN_RES_GET_TOTAL_PRICE(@RES_CODE)
	      ,@PAY_PRICE = DBO.FN_RES_GET_PAY_PRICE(@RES_CODE)
	      ,@ATT_CODE = ATT_CODE
	      ,@CUS_NAME = RC.CUS_NAME
	FROM   RES_MASTER_DAMO RM
	       INNER JOIN PKG_DETAIL PKD
	            ON  PKD.PRO_CODE = RM.PRO_CODE
	       INNER JOIN PKG_MASTER PKM
	            ON  PKM.MASTER_CODE = PKD.MASTER_CODE
	       INNER JOIN RES_CUSTOMER_DAMO RC
	            ON  RC.RES_CODE = RM.RES_CODE
	                AND RC.SEQ_NO = 1
	WHERE  RM.RES_CODE = @RES_CODE
	
	SELECT @CHECK_FLAG = CASE 
	                          WHEN @ATT_CODE = '1' AND @TOTAL_PRICE - @PAY_PRICE = 0 THEN 'T'
	                          ELSE 'F'
	                     END
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@TEST 
	--SET @CHECK_FLAG = 'T'
	
	IF @CHECK_FLAG = 'T'
	BEGIN
	    -- "마켓_결제완료" 알림톡 전송 기록 확인 후 전송 (1회전송)
	    IF NOT EXISTS(
	           SELECT 1
	           FROM   SEND.dbo.ALT_MESSAGE_MASTER MM
	                  INNER JOIN SEND.dbo.MZSENDLOG ML
	                       ON  ML.SN = MM.SN
	           WHERE  MM.RES_CODE = @RES_CODE
	                  AND RCPT_MSG = 'success'
	                  AND TMPL_CD = 'SYS_AT_0150'
	       )
	    BEGIN
	        DECLARE @PHONE_NUM VARCHAR(16)
	        DECLARE @SMS_SND_NUM VARCHAR(16)
	        DECLARE @CUS_NO INT
	        DECLARE @CONTS_TXT VARCHAR(4000)
	        DECLARE @REQ_DTM VARCHAR(14)
	        
	        /*-- "참좋은마켓_주문 접수" 기록에서 고객 전화번호, 담당자 전화번호, 고객 번호 참조
	        SELECT @PHONE_NUM = PHONE_NUM
	              ,@SMS_SND_NUM = SMS_SND_NUM
	              ,@CUS_NO = CUS_NO
	        FROM   SEND.dbo.ALT_MESSAGE_MASTER MM
	               INNER JOIN SEND.dbo.MZSENDLOG ML
	                    ON  ML.SN = MM.SN
	        WHERE  MM.RES_CODE = @RES_CODE
	               AND RCPT_MSG = 'success'
	               AND TMPL_CD = 'SYS_AT_0124'			
	       */
	       -- 예약정보에서 고객전화번호, 고객번호 가져오기        
	        SELECT @PHONE_NUM = NOR_TEL1+NOR_TEL2+NOR_TEL3
	              ,@SMS_SND_NUM = '0221884000'
	              ,@CUS_NO = CUS_NO
	        FROM   RES_MASTER_damo MM
	        WHERE  MM.RES_CODE = @RES_CODE
	        
	        SELECT @CONTS_TXT = CONTS_TXT
	        FROM   SEND.dbo.NVMOBILECONTENTS A WITH(NOLOCK)
	        WHERE  USE_YN = 'Y'
	               AND A.KAKAO_TMPL_CD IN (SELECT DATA
	                                       FROM   Diablo.dbo.FN_SPLIT('SYS_AT_0150' ,','))
	               AND A.KAKAO_INSP_STATUS = 'APR'
	               AND A.KAKAO_TMPL_STATUS IN ('A' ,'R')
	        
	        --TEST
	        --SET @CONTS_TXT = REPLACE(@CONTS_TXT,'#{NAME}', 'TEST')
	        --SET @CONTS_TXT = REPLACE(@CONTS_TXT,'#{예약번호}', @RES_CODE)
	        --SET @CONTS_TXT = REPLACE(@CONTS_TXT,'#{상품가}', REPLACE(CONVERT(VARCHAR(50), CAST(1111111 AS MONEY), 1) , '.00', '') + '원')
	        
	        --SET @PHONE_NUM = '01048506876'
	        
	        SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{NAME}' ,@CUS_NAME)
	        SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{예약번호}' ,@RES_CODE)
	        SET @CONTS_TXT = REPLACE(@CONTS_TXT ,'#{상품가}' ,REPLACE(CONVERT(VARCHAR(50) ,CAST(@TOTAL_PRICE AS MONEY) ,1) ,'.00' ,'') + '원')
	        
	        
	        SET @REQ_DTM = FORMAT(GETDATE() , 'yyyyMMddHHmmss') -- 현재시간 -- CONVERT(VARCHAR(10) ,GETDATE() ,112) + REPLACE(CONVERT(VARCHAR(8) ,GETDATE() ,108) ,':' ,'') 
	        
	        EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT @SENDER_KEY = 'f1e8319931392a3c30bb6fdef415f67ef87aa58c' -- 고정값
	            ,@PHONE_NUM = @PHONE_NUM
	            ,@TMPL_CD = 'SYS_AT_0150' -- 고정값
	            ,@SND_MSG = @CONTS_TXT
	            ,@REQ_DTM = @REQ_DTM
	            ,@SUBJECT = '참좋은마켓_결제 완료 (채널 추가' -- 고정값
	            ,@SMS_SND_NUM = @SMS_SND_NUM
	            ,@REQ_DEPT_CD = '529' -- 고정값
	            ,@REQ_USR_ID = '9999999' -- 고정값
	            ,@SMS_SND_YN = NULL
	            ,@TR_TYPE_CD = 'R' -- 고정값
	            ,@RES_CODE = @RES_CODE
	            ,@CUS_NO = @CUS_NO
	            ,@AGT_CODE = NULL
	            ,@EMP_SEQ = NULL
	            ,@CUS_NAME = NULL
	            ,@ATTACHMENT='{"button" : [{"name" : "채널추가","type" : "AC" }]}'

	    END
	END
END
GO
