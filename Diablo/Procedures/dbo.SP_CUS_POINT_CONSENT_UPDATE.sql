USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_CUS_POINT_CONSENT_UPDATE  10630082  , 1000 , '가입포인트 테스트'
■ Description				: 사용자 포인트 약관동의
■ Input Parameter			:                  
		@CUS_NO				: 고객 고유번호
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_CUS_POINT_CONSENT_UPDATE  
■ Author					: 임형민  
■ Date						: 2010-05-04  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-05-04       임형민			최초생성  
   2010-12-08		박형만			CUS_MEMBER 도 업데이트
   2016-04-18		김성호			총 포인트 검색 쿼리 NEW_DATE DESC 정렬시 버그 발생,POINT_NO DESC 로 수정
   2018-11-02		박형만			포인트 지급시 중복방지 테이블에 넣음 (진행중) . INS_TYPE 추가 
   2018-11-06		박형만			INS_TYPE (0=회원가입,1=휴대폰번호입력) 추가 
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_CUS_POINT_CONSENT_UPDATE]
(	
	@CUS_NO							INT,
	@ACC_POINT_PRICE				MONEY					= 0,
	@TITLE							VARCHAR(100)			= ''
)

AS

	BEGIN
		-- 변수 선언
		DECLARE @CUS_DATE VARCHAR(200)

		DECLARE 	@CUS_NAME VARCHAR(50),
			@NOR_TEL1 VARCHAR(6),
			@NOR_TEL2 VARCHAR(5),
			@NOR_TEL3 VARCHAR(4),
			@POINT_NO INT 

		DECLARE @TOTAL_POINT MONEY, @TOTAL_POINT_ROWCNT INT
		DECLARE @ERROR1 INT, @ERROR2 INT, @ROWCNT1 INT, @ROWCNT2 INT

		-- 해당 고객이 회원 테이블에 아이디가 존재 할 경우에만 포인트를 적립해 준다.
		IF EXISTS (SELECT 1 FROM DBO.CUS_CUSTOMER_DAMO(NOLOCK) WHERE CUS_NO = @CUS_NO AND ISNULL(CUS_ID, '') <> '') 
		BEGIN
			BEGIN TRAN

				-- 포인트 동의 여부를 변경한다.
				UPDATE DBO.CUS_CUSTOMER_DAMO
					SET POINT_CONSENT = 'Y',
						POINT_CONSENT_DATE = GETDATE()
				WHERE CUS_NO = @CUS_NO
				UPDATE DBO.CUS_MEMBER
					SET POINT_CONSENT = 'Y',
						POINT_CONSENT_DATE = GETDATE()
				WHERE CUS_NO = @CUS_NO
				
				-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
				IF @ERROR1 <> 0 AND @ROWCNT1 = 0
				BEGIN
					ROLLBACK TRAN				
				END
				ELSE
				BEGIN
					-- 포인트 지급을 해준다면..
					IF @ACC_POINT_PRICE <> 0
					BEGIN

						-- 해당 고객의 회원정보를 변수에 담는다.
						SELECT @CUS_DATE = 'CUS_ID:' + CUS_ID + ', CUS_NAME:' + CUS_NAME + ', BIRTH:' + ISNULL(CONVERT(VARCHAR(10),BIRTH_dATE,121),'') 
						, @CUS_NAME = CUS_NAME , @NOR_TEL1 = NOR_TEL1 , @NOR_TEL2 = NOR_TEL2 , @NOR_TEL3 = NOR_TEL3 
						FROM DBO.CUS_MEMBER(NOLOCK)
						WHERE CUS_NO = @CUS_NO

						-- 같은 고객 고유번호로 회원 가입포인트가 없다면 회원 가입포인트를 적립해 준다.
						-- AND 같은 휴대폰 번호로 적립 내역이 없다면 적립 해준다 
						IF NOT EXISTS (SELECT 1 FROM DBO.CUS_POINT(NOLOCK) WHERE CUS_NO = @CUS_NO AND POINT_TYPE = 1 AND ACC_USE_TYPE = 3)
							AND NOT EXISTS ( SELECT 1 FROM CUS_POINT_INS_HISTORY (NOLOCK) WHERE NOR_TEL1 = @NOR_TEL1 AND NOR_TEL2 = @NOR_TEL2 AND NOR_TEL3 = @NOR_TEL3 AND INS_TYPE = 0  ) 
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

							-- 포인트 약관 동의 축하포인트를 지급한다.
							INSERT INTO DBO.CUS_POINT (CUS_NO,POINT_TYPE, ACC_USE_TYPE, [START_DATE], END_DATE, POINT_PRICE, TITLE, TOTAL_PRICE, REMARK, NEW_CODE, NEW_DATE)
							VALUES (@CUS_NO, 1, 3, GETDATE(), DATEADD(YEAR, +3, GETDATE()), @ACC_POINT_PRICE, @TITLE, @TOTAL_POINT + @ACC_POINT_PRICE, @CUS_DATE, '9999999', GETDATE())

							-- 신규 포인트 번호 
							SET @POINT_NO  = @@IDENTITY 

							-- 이름 , 휴대폰으로 가입 포인트 테이블에 넣는다 (중복 지급 방지 2018-11-02 16:50 ) 
							INSERT INTO CUS_POINT_INS_HISTORY( CUS_NAME, NOR_TEL1, 	NOR_TEL2 , NOR_TEL3 ,CUS_NO	, POINT_NO , INS_TYPE  ) 
							VALUES ( @CUS_NAME , @NOR_TEL1 , @NOR_TEL2 , @NOR_TEL3 , @CUS_NO , @POINT_NO  , 0 ) 

							-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
							IF @ERROR2 <> 0 AND @ROWCNT2 = 0
							BEGIN
								ROLLBACK TRAN				
							END
						END
					END
				END
			COMMIT TRAN
		END
	END
GO
