USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: ZP_CUS_SLEEP_LAST_INFO_SND_INSERT
■ DESCRIPTION				: 휴면 대상 고객 안내 발송 및 휴면 전환
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
   2020-06-22		김성호			최초생성
   2020-06-24		김성호			버튼 FORM 추가
   2020-06-29		김성호			CS팀 요청으로 발송시간 0910 -> 1130으로 변경
   2021-01-27		김영민			휴면회원 조건 추가(포인트/상담/구매이력)
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_CUS_SLEEP_LAST_INFO_SND_INSERT]
	@SENDER_KEY		VARCHAR(40)
AS 
BEGIN
	
	DECLARE
		@TMPL_CD VARCHAR(20) = 'SYS_AT_0115',		-- 사용 템플릿 번호
		@TODAY DATE = CONVERT(DATE, GETDATE()),		-- 오늘 YYYY-MM-DD 00:00:00
		@SUBJECT VARCHAR(40) = '휴면안내',			-- [LMS 제목]
		@SMS_SND_NUM VARCHAR(16) = '02-2188-4000',	-- [사전등록된 발신자 전화번호]
		@REQ_DEPT_CD VARCHAR(50) = '529',			-- [발송요청부서코드]
		@REQ_USR_ID VARCHAR(50) = '9999999',		-- [발송요청자ID]
		@SMS_SND_YN	VARCHAR(1) = 'Y',				-- [알림톡 발송실패시 문자우회발송여부] : [Y: 발송함, N: 발송안함(기본값)]
		@TR_TYPE_CD VARCHAR(1) = 'B',				-- [발송유형] : [R : 실시간발송 B : 배치발송(기본값)]
		@CUS_NO INT,								-- 고객번호
		@CUS_NAME VARCHAR(20),						-- 고객명
		@CUS_ID VARCHAR(20),						-- 고객 아이디
		@NOR_TEL VARCHAR(20),						-- 전화번호
		@CONTS_TXT NVARCHAR(4000),					-- 발송내역
        @DATE_STR VARCHAR(14);	                    -- 발송일시
	
	-- 버튼 Form
	DECLARE @ATTACHMENT NVARCHAR(4000) = N'{"button" : [{ "name" : "간편 로그인하기", "type" : "WL", "url_mobile" : "http://vgt.kr/u/FH", "url_pc" : "http://vgt.kr/u/FH" }]}'
	
	-- 발송요청일시
    IF CONVERT(DATETIME, (CONVERT(VARCHAR(10), CONVERT(DATE, GETDATE())) + ' 11:30')) > GETDATE()
        SET @DATE_STR = CONVERT(VARCHAR(8), @TODAY, 112) + '113000';
    ELSE
        SET @DATE_STR = CONVERT(VARCHAR(8), GETDATE(), 112) + REPLACE(CONVERT(VARCHAR(8),GETDATE(),114),':','')

	DECLARE USER_CURSOR CURSOR FOR

		-- 휴면회원 대상자 조회
		SELECT A.CUS_NO, A.CUS_NAME, A.CUS_ID, (A.NOR_TEL1 + A.NOR_TEL2 + A.NOR_TEL3) 
		FROM Diablo.dbo.CUS_MEMBER A WITH(NOLOCK)
		WHERE A.LAST_LOGIN_DATE < DATEADD(DD, 1, DATEADD(DAY, -365, @TODAY))
		AND A.CUS_NO  NOT IN  --포인트 이력History안봄
					(SELECT  CUS_NO FROM CUS_POINT  WHERE NEW_DATE  >   DATEADD(DAY, -365, @TODAY)
					AND NEW_DATE  < DATEADD(DD, 1, @TODAY)  AND POINT_NO  NOT IN  (
					SELECT  CUS_POINT.POINT_NO
					FROM CUS_POINT  WHERE POINT_TYPE  = '2' AND ACC_USE_TYPE = '2')
					GROUP BY CUS_NO)
		AND A.CUS_NO NOT IN --상담이력
					(SELECT  CUS_NO FROM SIRENS.CTI.CTI_CONSULT  WHERE CONSULT_DATE > DATEADD(DAY, -365, @TODAY) AND
					CONSULT_DATE < DATEADD(DD, 1, @TODAY) 
					GROUP BY SIRENS.CTI.CTI_CONSULT.CUS_NO)
		AND A.CUS_NO NOT IN--출발이력(결재완료건)
					(SELECT A.CUS_NO FROM RES_CUSTOMER_DAMO A  JOIN 
					RES_MASTER B ON A.RES_CODE = B.RES_CODE 
					WHERE B.DEP_DATE >  DATEADD(DAY, -365, @TODAY)
					AND B.DEP_DATE + 1 < DATEADD(DD, 1, @TODAY) AND B.RES_STATE  IN('4') GROUP BY A.CUS_NO )		
		 AND  ISNULL(A.FORMEMBER_YN,'N') <> 'Y'  --평생회원제외 
		
	OPEN USER_CURSOR

	FETCH NEXT FROM USER_CURSOR	INTO @CUS_NO, @CUS_NAME, @CUS_ID, @NOR_TEL

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 알림발송
		IF LEN(@NOR_TEL) >= 10
		BEGIN
			
			SELECT @CONTS_TXT = REPLACE(A.CONTS_TXT, '#{NAME}', @CUS_NAME)
			FROM SEND.dbo.NVMOBILECONTENTS A WITH(NOLOCK)
			WHERE A.KAKAO_TMPL_CD = @TMPL_CD;
			
			--PRINT @CONTS_TXT

			EXEC SEND.DBO.XP_ALT_MESSAGE_INSERT @SENDER_KEY, @NOR_TEL, @TMPL_CD, @CONTS_TXT, @DATE_STR, @SUBJECT, @SMS_SND_NUM, @REQ_DEPT_CD, @REQ_USR_ID, @SMS_SND_YN, @TR_TYPE_CD, '', @CUS_NO, @CUS_NAME, NULL, NULL, @ATTACHMENT
		END
		
		-- 휴면회원 전환
		EXEC DBO.XP_CUS_MEMBER_SLEEP_INSERT @CUS_NO, 1

		FETCH NEXT FROM USER_CURSOR	INTO @CUS_NO, @CUS_NAME, @CUS_ID, @NOR_TEL
	END

	CLOSE USER_CURSOR
	DEALLOCATE USER_CURSOR
END	
GO
