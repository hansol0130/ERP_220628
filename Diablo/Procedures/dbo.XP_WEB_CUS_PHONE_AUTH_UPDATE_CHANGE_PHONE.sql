USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*================================================================================================================
■ USP_NAME					: XP_WEB_CUS_PHONE_AUTH_UPDATE_CHANGE_PHONE
■ DESCRIPTION				: 휴대폰 번호 인증 결과 휴대폰변경 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec XP_WEB_CUS_PHONE_AUTH_UPDATE_CHANGE_PHONE @SEQ_NO=24,@AUTH_KEY=NULL,
		 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2018-08-27		박형만			최초생성
   2018-11-06		김남훈			포인트 지급 추가
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_CUS_PHONE_AUTH_UPDATE_CHANGE_PHONE]
	--@SEQ_NO		INT,
	--@AUTH_KEY	VARCHAR(100),
	--@AUTH_NO	VARCHAR(10),
	@CUS_NO INT,
	@NOR_TEL1	VARCHAR(3),
	@NOR_TEL2	VARCHAR(4),
	@NOR_TEL3	VARCHAR(5),
	@REMARK VARCHAR(1000),
	@EMP_CODE	VARCHAR(7) ='9999999'

AS 
BEGIN
	DECLARE @CUS_DATE VARCHAR(200),
			@TEL_INS_YN VARCHAR(1) = 'N',
			@POINT_NO INT,
			@TOTAL_POINT MONEY, 
			@TOTAL_POINT_ROWCNT INT,
			@ERROR1 INT, 
			@ERROR2 INT, 
			@ROWCNT1 INT, 
			@ROWCNT2 INT
	
	EXEC XP_CUS_CUSTOMER_HISTORY_INSERT  
		--@CUS_ID = @CUS_ID,  -- 아이디추가 
		@CUS_NO = @CUS_NO, 
		--@CUS_NAME = @CUS_NAME,
		--@BIRTH_DATE = @BIRTH_DATE,
		--@GENDER = @GENDER,

		@NOR_TEL1 = @NOR_TEL1,
		@NOR_TEL2 = @NOR_TEL2,
		@NOR_TEL3 = @NOR_TEL3,
		
		@EMP_CODE = @EMP_CODE , 
		@EDT_REMARK = '휴대폰번호변경' , 
		@EDT_TYPE  = 7 -- 고객병합  

	UPDATE CUS_CUSTOMER_DAMO 
		SET NOR_TEL1  = @NOR_TEL1 
		, NOR_TEL2  = @NOR_TEL2 
		, NOR_TEL3  = @NOR_TEL3 
		, EDT_dATE = GETDATE() 
		, EDT_CODE = @EMP_CODE
	WHERE CUS_NO = @CUS_NO 
	--SELECT TOP 100 * FROM CUS_CUSTOMER_DAMO
	--WHERE CUS_NO = 4228549 

	IF EXISTS ( SELECT * FROM CUS_MEMBER_SLEEP WHERE CUS_NO = @CUS_NO ) 
	BEGIN

		SELECT 
			@TEL_INS_YN = 'Y'
		FROM
			CUS_MEMBER_SLEEP
		WHERE
			CUS_NO = @CUS_NO
			AND NOR_TEL1 IS NOT NULL AND LEN(NOR_TEL1) > 0
			AND NOR_TEL2 IS NOT NULL AND LEN(NOR_TEL2) > 0
			AND NOR_TEL3 IS NOT NULL AND LEN(NOR_TEL3) > 0

		UPDATE CUS_MEMBER_SLEEP
			SET NOR_TEL1  = @NOR_TEL1 
			, NOR_TEL2  = @NOR_TEL2 
			, NOR_TEL3  = @NOR_TEL3 
			, EDT_dATE = GETDATE() 
			, EDT_CODE = @EMP_CODE
			, EDT_MESSAGE =  '휴대폰번호변경'
			, PHONE_AUTH_YN = 'Y' 
			, PHONE_AUTH_DATE = GETDATE() 
		WHERE CUS_NO =@CUS_NO 
	END 
	IF EXISTS ( SELECT * FROM CUS_MEMBER WHERE CUS_NO = @CUS_NO ) 
	BEGIN

		--저장되기 이전 TEL 값 확인 'Y' 기존에 전화번호 있는 고객
		SELECT 
			@TEL_INS_YN = 'Y'
		FROM
			CUS_MEMBER
		WHERE
			CUS_NO = @CUS_NO
			AND NOR_TEL1 IS NOT NULL AND LEN(NOR_TEL1) > 0
			AND NOR_TEL2 IS NOT NULL AND LEN(NOR_TEL2) > 0
			AND NOR_TEL3 IS NOT NULL AND LEN(NOR_TEL3) > 0

		UPDATE CUS_MEMBER
			SET NOR_TEL1  = @NOR_TEL1 
			, NOR_TEL2  = @NOR_TEL2 
			, NOR_TEL3  = @NOR_TEL3 
			, EDT_dATE = GETDATE() 
			, EDT_CODE = @EMP_CODE
			, EDT_MESSAGE = ''
			, PHONE_AUTH_YN = 'Y' 
			, PHONE_AUTH_DATE = GETDATE() 
		WHERE CUS_NO =@CUS_NO 
	END 

	---- 인증처리 실패 기타사유로 인한 ( 상이한 정보 및 기존회원 있음) 
	---- 승인실패업데이트 
	--UPDATE CUS_PHONE_AUTH 
	--SET  CUS_RESULT = @CUS_RESULT 
	--, CUS_NO = @CUS_NO 
	--, REMARK = @REMARK  -- 상세사유 

	--WHERE SEQ_NO = @SEQ_NO 
	--AND AUTH_KEY = @AUTH_KEY 

	--SELECT @@ROWCOUNT

	-- 포인트 지급 구문
	-- 기존 번호가 빈값일 경우
		IF(@TEL_INS_YN = 'N' AND GETDATE() < '2018-12-12 23:59:59.999')
		BEGIN
		-- 포인트 적립 내역이 있는
			IF NOT EXISTS ( SELECT 1 FROM CUS_POINT_INS_HISTORY (NOLOCK) WHERE NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3 AND INS_TYPE = 1  ) AND
			EXISTS( SELECT TOP 1 * FROM dbo.TMP_CUS_POINT_TARGET WITH(NOLOCK) WHERE CUS_NO = @CUS_NO)
			BEGIN
							
				-- 현재 총 포인트를 가져온다.
				SELECT TOP 1 @TOTAL_POINT = TOTAL_PRICE
				FROM DBO.CUS_POINT WITH(NOLOCK)
				WHERE CUS_NO = @CUS_NO
				--ORDER BY NEW_DATE DESC
				ORDER BY POINT_NO DESC
							
				-- 총 포인트 조회 로우 개수를 가져온다
				SELECT @TOTAL_POINT_ROWCNT = @@ROWCOUNT

				-- 총 포인트 값이 있는지 체크한다
				IF @TOTAL_POINT_ROWCNT = 0
				BEGIN
					-- 총 포인트 값이 없다면 총포인트 값은 '0'이다
					SET @TOTAL_POINT = 0
				END

				-- 포인트 지급
				-- 포인트 약관 동의 축하포인트를 지급한다.
				INSERT INTO DBO.CUS_POINT (CUS_NO,POINT_TYPE, ACC_USE_TYPE, [START_DATE], END_DATE, POINT_PRICE, TITLE, TOTAL_PRICE, REMARK, NEW_CODE, NEW_DATE)
				VALUES (@CUS_NO, 1, 3, GETDATE(), DATEADD(YEAR, +3, GETDATE()), 5000, '번호 인증 포인트 지급', @TOTAL_POINT + 5000, @CUS_DATE, '9999999', GETDATE())

				-- 신규 포인트 번호 
				SET @POINT_NO  = @@IDENTITY 

				-- 포인트 지급 등록
				-- 이름 , 휴대폰으로 가입 포인트 테이블에 넣는다 (중복 지급 방지 2018-11-02 16:50 ) 
				INSERT INTO CUS_POINT_INS_HISTORY( CUS_NAME, NOR_TEL1, 	NOR_TEL2 , NOR_TEL3 ,CUS_NO	, POINT_NO , INS_TYPE  ) 
				SELECT CUS_NAME, @NOR_TEL1, @NOR_TEL2, @NOR_TEL3, @CUS_NO, @POINT_NO, 1
				FROM
				CUS_CUSTOMER_damo
				WHERE 
				CUS_NO = @CUS_NO

				-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
				IF @ERROR2 <> 0 AND @ROWCNT2 = 0
				BEGIN
					ROLLBACK TRAN				
				END
			END
		END
END 


GO
