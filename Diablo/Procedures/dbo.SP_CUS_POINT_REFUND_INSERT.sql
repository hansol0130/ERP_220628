USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: SP_CUS_POINT_REFUND_INSERT  
■ Description				: 사용자 사용취소(환불) 포인트 저장
■ Input Parameter			:                  
		@CUS_NO				: 고객 고유번호
		@RFD_POINT_PRICE	: 사용취소(환불) 적립 포인트
		@RES_CODE			: 예약코드
		@NEW_CODE			: 작성자 코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_CUS_POINT_REFUND_INSERT 4153295, 5000, 'RP1005146880', '9999999'  
■ Author					: 임형민  
■ Date						: 2010-05-20  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-05-20       임형민			최초생성  
   2010-09-13       임형민			'환불'을 '사용취소'로 변경
   2011-09-08						포인트 환불 적립시 - 로 입력   
   2011-12-06						환불시 사용 된 내역 각각의 환불내역 저장 . 로직 변경
   2015-02-13		박형만			환불시 사용-적립-사용 건에 대한 처리. SEQ_NO 순차적 일련번호로 수정 
   2016-07-19		박형만			환불시 사용-적립-사용 IS_CXL 잘못 처리된것 수정,환불결제내역쿼리수정  
   2017-08-14		박형만			양도 포인트 환불시 최상위 포인트의 적립타입  찾아서 넣기 
   2018-09-04		박형만			최상위 포인트 적립타입 버그 수정 
   2019-01-08		박형만			구매실적,회원가입 포인트 버그 수정 VIP추가적립(9) 추가
   2021-07-12		김성호			포인트 사용타입 구분 조건 변경 (1:상품적립, 2:관리자적립, 5:이벤트적립, 9:VIP추가적립) -> 회원가입 적립(71)
   2021-07-26		김성호			포인트 적립구분 이벤트적립(acc_use_type=5) 구매실적_적립 71 => 회원가입_적립 7 변경
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_CUS_POINT_REFUND_INSERT]
(	
	@CUS_NO						INT,
	@RFD_POINT_PRICE			MONEY,
	@RES_CODE					CHAR(12)				= '',
	@NEW_CODE					CHAR(7)					= '9999999'
)
AS
BEGIN 
	 
--DECLARE @CUS_NO						INT,
--	@RFD_POINT_PRICE			MONEY,
--	@RES_CODE					CHAR(12),
--	@NEW_CODE					CHAR(7)	
	
--SELECT @CUS_NO = 3951285 
--,@RFD_POINT_PRICE = 5100
--,@RES_CODE = 'RP1108222264'
--,@NEW_CODE = '9999999'
		
	DECLARE @ERROR_MSG VARCHAR(100) = ''
	
	BEGIN TRY 
	
		-- 임시저장 남은 환불 포인트 저장
		DECLARE @TMP_RFD_POINT_PRICE INT 
		DECLARE @RFD_TOTAL_POINT_PRICE INT 
		SET @TMP_RFD_POINT_PRICE = @RFD_POINT_PRICE 
		SET @RFD_TOTAL_POINT_PRICE = @RFD_POINT_PRICE
	
		--환불상세 데이터 입력 임시 테이블 (포인트사용내역)
		DECLARE @TMP_REFUND_LIST TABLE 
		(
			ID				INT IDENTITY(1,1),
			POINT_NO		INT,
			SEQ_NO			INT,
			ACC_POINT_NO	INT,
			RFD_POINT_PRICE	MONEY,
			ACC_USE_TYPE	INT  -- 원래 적립 포인트 
		)

		------------상세 환불 포인트를 계산 하기 위해 커서 사용 --------
		--커서변수
		DECLARE @HIS_POINT_NO INT , @ACC_POINT_NO INT, @REMAIN_RFD_POINT_PRICE INT, @HIS_SEQ_NO INT , @ACC_USE_TYPE INT 
	
		DECLARE CSR_USE_POINT_LIST CURSOR FOR

			SELECT 
				A.POINT_NO , A.ACC_POINT_NO , A.POINT_PRICE AS REMAIN_RFD_POINT_PRICE ,
				--A.SEQ_NO , 
				ROW_NUMBER() OVER ( ORDER BY A.POINT_NO ASC , ACC_POINT_NO ASC ) AS SEQ_NO,  -- 결제사용후-관리자적립-결제사용 일경우 문제때문에 수정 
				--(SELECT ACC_USE_TYPE FROM CUS_POINT WHERE A.ACC_POINT_NO = POINT_NO ) AS ACC_USE_TYPE 
				--DBO.XN_CUS_POINT_TOP_ACC_CODE(A.POINT_NO) as ACC_USE_TYPE   --   2017-08-14 원 포인트 조회 
				DBO.XN_CUS_POINT_TOP_ACC_CODE(A.ACC_POINT_NO) as ACC_USE_TYPE  --  2018-09-04 원 포인트 조회 버그 수정 
			FROM CUS_POINT_HISTORY  A
				INNER JOIN CUS_POINT B 
					ON A.POINT_NO = B.POINT_NO 
					AND B.IS_CXL = 0  -- 취소가 아닌것만
			WHERE B.CUS_NO = @CUS_NO  
			AND B.RES_CODE = @RES_CODE --해당 예약으로 사용된것 
			ORDER BY A.ACC_POINT_NO ASC    

		--커서열기
		OPEN CSR_USE_POINT_LIST
	
		--다음레코드로
		FETCH NEXT FROM CSR_USE_POINT_LIST INTO @HIS_POINT_NO,@ACC_POINT_NO, @REMAIN_RFD_POINT_PRICE, @HIS_SEQ_NO, @ACC_USE_TYPE
	
			-- WHILE문으로 레코드 값 출력
			-- @@FETCH_STATUS : 0 = 성공, -1 = 실패(커서위치 잘못), -2 = 실패 (레코드 없음)
			WHILE @@FETCH_STATUS = 0  
			BEGIN
		
				-- 현재ROW 환불 포인트 
				DECLARE @ROW_RFD_POINT_PRICE INT 
				--SET @ROW_RFD_POINT_PRICE = @RFD_POINT_PRICE - @REMAIN_RFD_POINT_PRICE 
		
				-- 환불 포인트가 환불가능 포인트 보다 많으면 
				IF( @TMP_RFD_POINT_PRICE > @REMAIN_RFD_POINT_PRICE ) 
				BEGIN 
					-- 남은 환불 포인트 임시 저장 
					SET @TMP_RFD_POINT_PRICE = @TMP_RFD_POINT_PRICE - @REMAIN_RFD_POINT_PRICE 
					SET @ROW_RFD_POINT_PRICE = @REMAIN_RFD_POINT_PRICE 
				END 
				ELSE 
				BEGIN
					SET @ROW_RFD_POINT_PRICE = @RFD_TOTAL_POINT_PRICE
					SET @TMP_RFD_POINT_PRICE = 0  --남은 포인트 없음
				END 
		
				--****환불상세 내역 임시테이블 입력
				INSERT INTO @TMP_REFUND_LIST ( POINT_NO ,SEQ_NO , ACC_POINT_NO ,RFD_POINT_PRICE ,ACC_USE_TYPE)
				SELECT @HIS_POINT_NO , @HIS_SEQ_NO ,  @ACC_POINT_NO ,@ROW_RFD_POINT_PRICE ,@ACC_USE_TYPE
		
				--환불 포인트가 남았다면
				IF ( @TMP_RFD_POINT_PRICE > 0 )
				BEGIN  
					--남은포인트 저장 
					SET @RFD_TOTAL_POINT_PRICE = @TMP_RFD_POINT_PRICE
					--다음 레코드로 
					FETCH NEXT FROM CSR_USE_POINT_LIST INTO @HIS_POINT_NO,@ACC_POINT_NO, @REMAIN_RFD_POINT_PRICE, @HIS_SEQ_NO, @ACC_USE_TYPE
				END 
				ELSE 
				BEGIN
					--환불 작업 종료 
					GOTO CLOSE_CORSOR
				END 
			END 

			-- GOTO 별칭 구문
			CLOSE_CORSOR:
	
		CLOSE CSR_USE_POINT_LIST
		DEALLOCATE CSR_USE_POINT_LIST 

		--SELECT -1, SEQ_NO,ACC_POINT_NO,RFD_POINT_PRICE , @NEW_CODE , GETDATE() , POINT_NO 
		--FROM @TMP_REFUND_LIST	

		--2016-07-19 버그로 삭제 , 여러건 취소 될경우 고려안됨 
		--DECLARE @ORG_POINT_NO INT  --원래 사용 포인트 
		--SET @ORG_POINT_NO = (SELECT TOP 1 POINT_NO FROM @TMP_REFUND_LIST ) 
	
		-- 사용자의 남은 포인트 리스트를 변수에 저장
		DECLARE @REMAIN_POINT_PRICE INT 
		SET @REMAIN_POINT_PRICE = 
		  ISNULL((SELECT SUM(POINT_PRICE) FROM CUS_POINT A WHERE CUS_NO = @CUS_NO AND POINT_TYPE = 1 ),0)
		- ISNULL((SELECT SUM(POINT_PRICE) FROM CUS_POINT A WHERE CUS_NO = @CUS_NO AND POINT_TYPE = 2 ),0)
		-- 환불은 사용내역에 -로 저장되기에 사용내역 전체 SUM 해도 됨
		--SELECT @REMAIN_POINT_PRICE 

	
		BEGIN TRAN 
			
			-- *********환불내역 마스터 입력 POINT_TYPE=2 : 사용 ,  ACC_USE_TYPE =6 : 사용취소  IS_CXL = 1 
			-- 저장시 사용계정에 (-) 포인트로 입력한다.  
			SET @ERROR_MSG  = '환불내역 마스터 입력'
			INSERT INTO DBO.CUS_POINT (CUS_NO, POINT_TYPE, ACC_USE_TYPE, START_DATE, END_DATE, 
				POINT_PRICE, RES_CODE, TITLE, TOTAL_PRICE, 
				NEW_CODE, NEW_DATE, IS_CXL)
			SELECT @CUS_NO , 2 AS POINT_TYPE, 6 AS ACC_USE_TYPE , NULL , NULL , 
				-@RFD_POINT_PRICE, @RES_CODE, '관리자 사용취소', @REMAIN_POINT_PRICE + @RFD_POINT_PRICE, 
				@NEW_CODE, GETDATE() , 1 
				
			-- *********원래 포인트 내역 IS_CXL = 1 업데이트 
			SET @ERROR_MSG  = '포인트내역 취소로 업데이트'
			UPDATE CUS_POINT
			SET IS_CXL = 1 
			--WHERE POINT_NO  = @ORG_POINT_NO  
			WHERE POINT_NO IN( SELECT POINT_NO FROM @TMP_REFUND_LIST )  --전체 환불내역건의 원래 포인트 내역 
			
			-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
			IF @@ERROR <> 0 AND @@ROWCOUNT = 0
			BEGIN
				ROLLBACK TRAN
				RETURN 			
			END
			
			DECLARE @CXL_POINT_NO INT 
			SET @CXL_POINT_NO = @@IDENTITY
			-- *********환불 상세 내역 입력 
			SET @ERROR_MSG  = '환불내역 상세내역 입력'
			INSERT INTO CUS_POINT_HISTORY ( POINT_NO,SEQ_NO,ACC_POINT_NO,POINT_PRICE,NEW_CODE,NEW_DATE , ACC_TYPE, CXL_POINT_NO)
			SELECT @CXL_POINT_NO ,SEQ_NO,ACC_POINT_NO,-RFD_POINT_PRICE , @NEW_CODE , GETDATE() , ACC_USE_TYPE , POINT_NO 
			FROM @TMP_REFUND_LIST
			
			--------------------------------------------------------
			-- 사용취소(환불) 내역을 입금 테이블에 저장한다.
			SET @ERROR_MSG  = '포인트 입금내역 입력 '
			--EXEC SP_PAY_POINT_INSERT @CUS_NO, 0, @RFD_POINT_PRICE, @RES_CODE, @NEW_CODE, 'Y'
			DECLARE @TMP_PAYLIST TABLE ( ID INT IDENTITY(1,1),PAY_ACC_TYPE INT,POINT_PRICE INT )
			
			INSERT INTO @TMP_PAYLIST (PAY_ACC_TYPE, POINT_PRICE)
			SELECT ACC_TYPE, SUM(POINT_PRICE) FROM 
			(
				-- 구매실적_적립 71, 회원가입_적립 7 (PaymentTypeEnum)
				SELECT
					--(CASE WHEN ACC_USE_TYPE IN (1, 2, 5, 9) THEN 71 ELSE 7 END) AS ACC_TYPE,	-- (1:상품적립, 2:관리자적립, 5:이벤트적립, 9:VIP추가적립) 
					(CASE WHEN ACC_USE_TYPE IN (1, 2, 9) THEN 71 ELSE 7 END) AS ACC_TYPE,		-- (1:상품적립, 2:관리자적립, 5:이벤트적립, 9:VIP추가적립) 
					RFD_POINT_PRICE AS POINT_PRICE 
				FROM @TMP_REFUND_LIST 
			) TBL 
			GROUP BY ACC_TYPE -- 히스토리별로 나누어서 입력 
			
			-- 변수 선언
			DECLARE @PAY_SEQ INT, @CUS_NAME VARCHAR(40), @PRO_CODE VARCHAR(20)
			
			-- 고객 고유번호로 고객명을 가져온다.
			SELECT @CUS_NAME = CUS_NAME FROM CUS_CUSTOMER_DAMO WHERE CUS_NO = @CUS_NO

			-- 예약번호로 상품코드를 가져온다.
			SELECT @PRO_CODE = PRO_CODE FROM RES_MASTER_DAMO WHERE RES_CODE = @RES_CODE
			
			DECLARE @LOOP_CNT INT 
			DECLARE @PAY_TYPE INT , @PAY_POINT_PRICE INT
			SET @LOOP_CNT = 1 
			WHILE (SELECT MAX(ID) FROM @TMP_PAYLIST ) + 1   > @LOOP_CNT 
			BEGIN
				SELECT 
					@PAY_TYPE = PAY_ACC_TYPE, 
					@PAY_POINT_PRICE = POINT_PRICE 
				FROM @TMP_PAYLIST 
				WHERE ID = @LOOP_CNT 
				
				SET @ERROR_MSG  = '입금마스터 테이블 결제취소 입력 '
				-- 입금 마스터 테이블에 포인트 결제취소 내역 저장
				INSERT INTO DBO.PAY_MASTER_DAMO (PAY_TYPE, PAY_METHOD, PAY_NAME, PAY_PRICE, PAY_DATE, CUS_NO, NEW_CODE, NEW_DATE)
				VALUES (@PAY_TYPE, 0, @CUS_NAME, -@PAY_POINT_PRICE, GETDATE(), @CUS_NO, '9999999', GETDATE())

				-- 입금순번을  가져온다
				SELECT @PAY_SEQ = @@IDENTITY 
			
				SET @ERROR_MSG  = '입금매칭 테이블 결제취소 입력 '
				-- 입금매칭 테이블에 포인트 결제취소 내역 저장
				INSERT INTO DBO.PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE, PART_PRICE, NEW_DATE, NEW_CODE)
				VALUES (@PAY_SEQ, 1, 0, @RES_CODE, @PRO_CODE, -@PAY_POINT_PRICE, GETDATE(), '9999999')
				
				SET @LOOP_CNT = @LOOP_CNT + 1 
			END 
			
			--------------------------------------------------------
				  
				
			--	-- 고객 포인트 테이블에 적립한 사용취소(환불) 데이터의 유효기간을 체크하여 유효기간이 지난 포인트에 대하여 소멸 처리한다.
			--	-- 보류 : 고객 컴플레인 소지 있음 . 포인트 기간이 만료 되어도 그날 저녁 12 시전 까지는 사용가능. 
			--	--EXEC SP_CUS_POINT_EXPIRE @NEW_POINT_NO, @CUS_NO, @NEW_CODE
	
			--	SET @LOOP_CNT = @LOOP_CNT + 1 
			--END
			
			SELECT ''
		COMMIT TRAN 
	END TRY
	BEGIN CATCH 
		SELECT @ERROR_MSG 
		ROLLBACK TRAN 
	END CATCH
END 



GO
