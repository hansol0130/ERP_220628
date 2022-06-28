USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ Server					: 110.11.22.90
■ Database					: DIABLO
■ USP_Name					: SP_PAY_POINT_INSERT  
■ Description				: 사용자 사용 포인트 저장
■ Input Parameter			:                  
		@CUS_NO				: 고객 고유번호
		@USE_TYPE			: 사용종류
		@USE_POINT_PRICE	: 사용 포인트
		@RES_CODE			: 예약코드
		@TITLE				: 제목
		@REMARK				: 비고
		@NEW_CODE			: 작성자 코드
		@ONLY_PAY			: 입금내역만 저장 여부
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_PAY_POINT_INSERT  
■ Author					: 임형민  
■ Date						: 2010-05-03  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-05-03       임형민			최초생성  
   2010-06-03		박형만			암호화적용
   2010-06-08		박형만			암호화적용
   2016-04-18		김성호			총 포인트 검색 쿼리 NEW_DATE DESC 정렬시 버그 발생,POINT_NO DESC 로 수정
-------------------------------------------------------------------------------------------------*/ 

CREATE PROC [dbo].[SP_PAY_POINT_INSERT]
(	
	@CUS_NO						INT,
	@USE_TYPE					INT,
	@USE_POINT_PRICE			MONEY,
	@RES_CODE					CHAR(12)				= '',
	@NEW_CODE					CHAR(7)					= '9999999',
	@ONLY_PAY					CHAR(1)					= 'N'
)

AS

	BEGIN
		-- 변수 선언
		DECLARE @PAY_SEQ INT
		DECLARE @CUS_NAME VARCHAR(40), @PRO_CODE VARCHAR(20), @TOTAL_POINT MONEY
		DECLARE @ERROR1 INT, @ERROR2 INT, @ROWCNT1 INT, @ROWCNT2 INT

		-- 고객 고유번호로 고객명을 가져온다.
		SELECT @CUS_NAME = CUS_NAME FROM CUS_CUSTOMER_DAMO WHERE CUS_NO = @CUS_NO

		-- 예약번호로 상품코드를 가져온다.
		SELECT @PRO_CODE = PRO_CODE FROM RES_MASTER_DAMO WHERE RES_CODE = @RES_CODE

		-- 현재 총 포인트를 가져온다.
		SELECT TOP 1 @TOTAL_POINT = TOTAL_PRICE
		FROM DBO.CUS_POINT WITH(NOLOCK)
		WHERE CUS_NO = @CUS_NO
		--ORDER BY NEW_DATE DESC
		ORDER BY POINT_NO DESC
	
		IF @TOTAL_POINT > 0
		BEGIN
			BEGIN TRAN
				-- 입금 마스터 테이블에 포인트 결제 내역 저장
				INSERT INTO DBO.PAY_MASTER_DAMO (PAY_TYPE, PAY_METHOD, PAY_NAME, PAY_PRICE, PAY_DATE, CUS_NO, NEW_CODE, NEW_DATE)
				VALUES (7, 0, @CUS_NAME, @USE_POINT_PRICE, GETDATE(), @CUS_NO, '9999999', GETDATE())

				-- 입금순번과 오류 개수, 적용 로우 개수를 가져온다
				SELECT @PAY_SEQ = @@IDENTITY, @ERROR1 = @@ERROR, @ROWCNT1 = @@ROWCOUNT
				
				-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
				IF @ERROR1 <> 0 AND @ROWCNT1 = 0
				BEGIN
					ROLLBACK TRAN				
				END
				ELSE
				BEGIN
					-- 입금매칭 테이블에 포인트 결제 내역 저장
					INSERT INTO DBO.PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE, PART_PRICE, NEW_DATE, NEW_CODE)
					VALUES (@PAY_SEQ, 1, 0, @RES_CODE, @PRO_CODE, @USE_POINT_PRICE, GETDATE(), '9999999')
					
					-- 오류 개수와 적용 로우 개수를 가져온다
					SELECT @ERROR2 = @@ERROR, @ROWCNT2 = @@ROWCOUNT
					
					-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
					IF @ERROR2 <> 0 AND @ROWCNT2 = 0
					BEGIN
						ROLLBACK TRAN				
					END
				END
			COMMIT TRAN
			
			-- 입금내역만 저장 하는 경우가 아니라면 포인트 사용 내역을 저장한다.
			IF @ONLY_PAY = 'N'
			BEGIN
				-- 포인트 사용내역 저장 프로시저 호출
				EXEC DBO.SP_CUS_POINT_HISTORY_INSERT @CUS_NO, @USE_TYPE, @USE_POINT_PRICE, @RES_CODE, '', '', @NEW_CODE	
			END
		END
	END
GO
