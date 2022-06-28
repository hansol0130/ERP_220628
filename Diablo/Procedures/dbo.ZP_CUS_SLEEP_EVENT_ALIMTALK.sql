USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: ZP_CUS_SLEEP_EVENT_ALIMTALK
■ DESCRIPTION				: 휴면 예정 회원 및 휴면 대상 이벤트 알림톡
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC DIABLO.DBO.ZP_CUS_SLEEP_LAST_INFO_SND_INSERT 'f1e8319931392a3c30bb6fdef415f67ef87aa58c'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2020-07-21		오준혁		    최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_CUS_SLEEP_EVENT_ALIMTALK]
	@TEST CHAR(1) = ''
AS
BEGIN
	
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    	
	DECLARE @TMPL_CD         VARCHAR(20) = 'SYS_AT_0116'	                   -- 사용 템플릿 번호
	       ,@SUBJECT         VARCHAR(40) = '휴면이벤트안내'	                   -- [LMS 제목]
	       ,@SMS_SND_NUM     VARCHAR(16) = '02-2188-4000'	                   -- [사전등록된 발신자 전화번호]
	       ,@REQ_DEPT_CD     VARCHAR(50) = '529'	                           -- [발송요청부서코드]
	       ,@REQ_USR_ID      VARCHAR(50) = '9999999'	                       -- [발송요청자ID]
	       ,@SMS_SND_YN      VARCHAR(1) = 'Y'	                               -- [알림톡 발송실패시 문자우회발송여부] : [Y: 발송함, N: 발송안함(기본값)]
	       ,@TR_TYPE_CD      VARCHAR(1) = 'R'	                               -- [발송유형] : [R : 실시간발송 B : 배치발송(기본값)]
	       ,@CUS_NO          INT	                                           -- 고객번호
	       ,@CUS_NAME        VARCHAR(20)	                                   -- 고객명
	       ,@CUS_ID          VARCHAR(20)	                                   -- 고객 아이디
	       ,@NOR_TEL         VARCHAR(20)	                                   -- 전화번호
	       ,@CONTS_TXT       NVARCHAR(4000)	                                   -- 발송내역
	       ,@DATE_STR        VARCHAR(14) = FORMAT(GETDATE(), 'yyyyMMddhhmmss') -- 발송일시
	       ,@ATTACHMENT      NVARCHAR(4000) = ''                               -- 버튼 Form
	       ,@SENDER_KEY      VARCHAR(40) = 'f1e8319931392a3c30bb6fdef415f67ef87aa58c' 
	
	
		
	
	/*
	* 1. 알림톡 대상자 목록 저장
	*/
	/*
	IF @TEST = ''
	BEGIN
		
		TRUNCATE TABLE EVT_CHANGE_DORMANT_MEMBER_TARGET
		
		INSERT INTO EVT_CHANGE_DORMANT_MEMBER_TARGET
		(
			CUS_NO,
			CUS_NAME,
			CUS_ID,
			TEL,
			LAST_LOGIN_DATE
		)
		SELECT temp.CUS_NO
			  ,temp.CUS_NAME
			  ,temp.CUS_ID
			  ,temp.TEL
			  ,temp.LAST_LOGIN_DATE
		FROM (
				-- 휴면 예정 회원
				SELECT CUS_NO
					  ,CUS_NAME
					  ,CUS_ID
					  ,(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) AS 'TEL'
					  ,LAST_LOGIN_DATE
				FROM   CUS_MEMBER A WITH(NOLOCK)
				WHERE  LAST_LOGIN_DATE > FORMAT(DATEADD(MONTH ,-11 ,GETDATE()) ,'yyyy-MM-dd')
					   AND LAST_LOGIN_DATE < FORMAT(DATEADD(DAY ,1 ,DATEADD(MONTH ,-9 ,GETDATE())) ,'yyyy-MM-dd') 
		
				UNION
		
				-- 휴면 대상자
	
				SELECT CUS_NO
					  ,CUS_NAME
					  ,CUS_ID
					  ,(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) AS 'TEL'
					  ,LAST_LOGIN_DATE
				FROM   CUS_MEMBER_SLEEP	
		) temp
	
	END
	ELSE IF @TEST = 'Y'
	BEGIN
		
		TRUNCATE TABLE EVT_CHANGE_DORMANT_MEMBER_TARGET
		
		INSERT INTO EVT_CHANGE_DORMANT_MEMBER_TARGET
		(
			CUS_NO,
			CUS_NAME,
			CUS_ID,
			TEL,
			LAST_LOGIN_DATE
		)		
		SELECT CUS_NO
		      ,CUS_NAME
		      ,CUS_ID
		      ,(NOR_TEL1 + NOR_TEL2 + NOR_TEL3) AS 'TEL'
		      ,LAST_LOGIN_DATE
		FROM   CUS_MEMBER
		WHERE CUS_NO = 12565618 OR CUS_NO = 12566088
		
	END

	*/
	
	
	-- 커서 생성
	DECLARE @CUS_NO_cur              INT
	       ,@CUS_NAME_cur            VARCHAR(20)
	       ,@CUS_ID_cur              VARCHAR(20)
	       ,@TEL_cur                 VARCHAR(15)
	
	DECLARE my_cursor CURSOR FAST_FORWARD READ_ONLY FOR

	SELECT CUS_NO
	      ,CUS_NAME
	      ,CUS_ID
	      ,TEL
	FROM   EVT_CHANGE_DORMANT_MEMBER_TARGET
	WHERE LEN(ISNULL(TEL,'')) > 10
	AND CUS_NO > 12259253
	
		
	OPEN my_cursor
	
	FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_ID_cur, @TEL_cur
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		/*
		[참좋은여행]
		#{NAME}님의 소중한 포인트를 확인해주세요

		#{NAME}님이 현재 참좋은여행에 적립 중이신 여행 포인트의 소멸 시한을 확인해주시기 바랍니다.
		참좋은여행은 2020년 2월 1일부터 소멸 예정 포인트의 유효기간을 연장해 드리고 있습니다. 혹시 고객님의 포인트 유효기간이 연장되지 않은 경우는 아래 번호로 문의주시기 바랍니다. 고객님의 포인트는 참좋은여행 홈페이지에 로그인 후 마이페이지에서 바로 확인 가능합니다.

		하루 속히 코로나 사태가 진정되어, 고객님을 꼭 다시 모실 수 있게 되기를 진심으로 바랍니다. 기다리겠습니다.

		● 문의 : CS지원 02-2185-2660
		● 기간 : #{포인트연장문의기간}

		▶ 홈페이지 바로가기 : #{홈페이지url}
		*/

		SELECT @CONTS_TXT = REPLACE(REPLACE(REPLACE(A.CONTS_TXT
			, '#{NAME}', @CUS_NAME_cur)
			, '#{포인트연장문의기간}', '2020-07-22 ~ 2020-08-04')
			, '#{홈페이지url}', 'http://vgt.kr/u/WPB7') -- 이벤트화면
		FROM SEND.dbo.NVMOBILECONTENTS A
		WHERE A.KAKAO_TMPL_CD = 'SYS_AT_0116';
		
		EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT @SENDER_KEY
											,@TEL_cur
											,@TMPL_CD
											,@CONTS_TXT
											,@DATE_STR
											,@SUBJECT
											,@SMS_SND_NUM
											,@REQ_DEPT_CD
											,@REQ_USR_ID
											,@SMS_SND_YN
											,@TR_TYPE_CD
											,''
											,@CUS_NO_cur
											,@CUS_NAME_cur
											,NULL
											,NULL
											,@ATTACHMENT
		    
	
		FETCH FROM my_cursor INTO @CUS_NO_cur, @CUS_NAME_cur, @CUS_ID_cur, @TEL_cur
	END
	
	CLOSE my_cursor
	DEALLOCATE my_cursor
	
	

END	
GO
