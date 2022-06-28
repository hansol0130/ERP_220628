USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_CUS_POINT_HISTORY_INSERT  
■ Description				: 사용자 사용 포인트 저장
■ Input Parameter			:                  
		@CUS_NO				: 고객 고유번호
		@USE_TYPE			: 사용종류
		@USE_POINT_PRICE	: 사용 포인트
		@RES_CODE			: 예약코드
		@TITLE				: 제목
		@REMARK				: 비고
		@NEW_CODE			: 작성자 코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_CUS_POINT_HISTORY_INSERT  
■ Author					: 임형민  
■ Date						: 2010-05-03  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-05-03       임형민			최초생성  
   2010-06-03		박형만			암호화 적용
   2011-12-07		박형만			사용내역에 적립타입 넣기 
   2012-02-16		박형만			포인트 부족시 사용안되게
   2012-02-16		박형만			양도 포인트 사용시 최초 적립 번호로 최초 적립 타입 찾아서 넣기 
   2012-10-11		박형만			사용될 포인트가 현재포인트 잔액보다 많으면 사용 안되도록
   2013-07-23		김성호			양도 포인트 최상위 ACC_TYPE 가져오도록 함수 사용 (DBO.XN_CUS_POINT_TOP_ACC_CODE)
   2013-08-14		박형만			포인트입금내역에 정회원(CUS_MEMBER)이름 을 가져온다
   2013-09-04		박형만			포인트사용시 최상위 적립 포인트 찾기 버그수정 ㅜ  2013-09-15:32:00
   2013-11-08		박형만			결제금액 체크 해서 예약결제상태 변경 하도록 수정 
   2013-12-10		박형만			포인트가 부족일때 당일 만료된 금액이 있다면(예약시작시점에는 포인트 있었을때) 관리자 추가 적립(만료유예적립) 후 차감  
   2016-04-18		박형만			NEW_DATE DESC 정렬시 버그 발생,POINT_NO DESC 로 수정 
   2017-01-11		박형만			정회원명(입금자명)을 휴면회원 테이블에서 가져옴
   2017-01-26		박형만			남은포인트 계산할대 마이너스 적립도 계산되도록 
   2017-02-01		박형만			@TARGET_POINT_NO 우선 차감 포인트 번호 추가 (잘못적립된경우 취소 차감할때 사용)
   2019-01-08		박형만			결제입력시 1구매실적,3회원가입 두가지로 구분. vip추가적립= 구매실적 적립으로
   2020-05-13		김성호			구매실적적립 타입 추가 (5:이벤트적립), SP 정리
   2021-03-03       오준혁			포인트가 먼저 적립된 순서대로 순차 사용 => 유효기간 임박한 순서대로 순차 사용으로 변경
   2021-07-26		김성호			포인트 적립구분 이벤트적립(acc_use_type=5) 구매실적_적립 71 => 회원가입_적립 7 변경
   2021-09-01		홍종우			Input Parameter @PRO_CODE 추가 (참좋은마켓용 Parameter)
   2022-03-221		김성호			포인트등록 오류 시 로그 등록(VGLog.dbo.SYS_ERP_LOG)
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_CUS_POINT_HISTORY_INSERT]
(	
	@CUS_NO						INT,
	@USE_TYPE					INT,
	@USE_POINT_PRICE			MONEY,
	@RES_CODE					CHAR(12)				= '',
	@TITLE						VARCHAR(100)			= '',
	@REMARK						VARCHAR(200)			= '',
	@NEW_CODE					CHAR(7)					= '9999999', 
	@IS_PAYMENT					INT, -- 포인트 결재여부 0=일반 , 1=결재입력
	@TARGET_POINT_NO			INT  = 0, -- 우선차감되어야 하는 포인트 (기본값0)
	@PRO_CODE                   VARCHAR(20) = ''
)
AS
BEGIN
		
	-- 트리거 실행 방지
	SET Context_Info 0x21884680
		
	-- 변수 선언
	DECLARE @POINT_NO INT, @ACC_POINT_NO INT, @SEQ_NO INT
	DECLARE @TOTAL_POINT MONEY, @REMAIN_POINT_PRICE MONEY, @BEFORE_POINT_PRICE MONEY, @ACC_TYPE INT 
		
	-- 현재 총 포인트를 가져온다.
	SELECT TOP 1 @TOTAL_POINT = TOTAL_PRICE
	FROM   DBO.CUS_POINT WITH(NOLOCK)
	WHERE  CUS_NO = @CUS_NO
	ORDER BY
		    POINT_NO DESC;
		
	-- 포인트가 부족할경우 에러 메시지 발생 
	IF @TOTAL_POINT < @USE_POINT_PRICE 
	BEGIN
		
		THROW 50001,'포인트가부족합니다',1; -- 이전 소스의 프로그램 연계성 때문에 그대로 남겨둠
		RETURN;
		
		--DECLARE @SPECIAL_POINT INT 
		--SET @SPECIAL_POINT = @USE_POINT_PRICE - @TOTAL_POINT 
		--DECLARE @NOW_DATE DATETIME 
		--SET @NOW_DATE = CONVERT(VARCHAR(10),GETDATE(),121) 

		---- 당일만료 포인트가 있으면 . 매 00시에 만료됨 
		--IF EXISTS ( SELECT * FROM CUS_POINT WITH(NOLOCK) WHERE CUS_NO = @CUS_NO 
		--	AND POINT_TYPE = 2 AND ACC_USE_TYPE = 2 
		--	AND NEW_DATE >= @NOW_DATE )
		--BEGIN
		--	--부족한 포인트 만큼 포인트 추가 적립(포인트 만료 유예 적립. 유효기간 하루)
		--	INSERT INTO CUS_POINT (CUS_NO,POINT_TYPE,ACC_USE_TYPE,START_DATE,END_DATE,
		--		POINT_PRICE,RES_CODE,TITLE,TOTAL_PRICE,NEW_CODE,NEW_DATE )
		--	VALUES (  @CUS_NO , 1 ,2 , @NOW_DATE, DATEADD(S,-1,DATEADD(D,1,@NOW_DATE)), 
		--		@SPECIAL_POINT,@RES_CODE , '포인트 만료 유예 적립', @TOTAL_POINT + @SPECIAL_POINT ,'9999999',GETDATE() ) 

		--	-- 현재 총 포인트를 가져온다.
		--	SELECT TOP 1 @TOTAL_POINT = TOTAL_PRICE
		--	FROM DBO.CUS_POINT
		--	WHERE CUS_NO = @CUS_NO
		--	--ORDER BY NEW_DATE DESC
		--	ORDER BY POINT_NO DESC
		--END 
		--ELSE 
		--BEGIN
		--	THROW 50001,'포인트가부족합니다',1
		--	RETURN 					
		--END 
	END

	-- 기존 예약정보를 무조건 찾는 로직에서 
	-- 참좋은마켓이 아니면 예약정보에서 PRO_CODE, PRO_NAME 검색
	-- 참좋은마켓이면(@PRO_CODE값이 존재하고 ATT_CODE='1') 입력값 PRO_CODE, PRO_NAME 사용
	IF NOT EXISTS (
	       SELECT *
	       FROM   PKG_MASTER A
	              INNER JOIN PKG_DETAIL B
	                   ON  B.MASTER_CODE = A.MASTER_CODE
	       WHERE  PRO_CODE = @PRO_CODE
	              AND ATT_CODE = '1'
	)
	BEGIN
		-- 예약정보 검색
		SELECT @TITLE = (CASE WHEN @USE_TYPE = 1 THEN PRO_NAME ELSE @TITLE END)
				,@PRO_CODE = PRO_CODE
		FROM   RES_MASTER_damo WITH(NOLOCK)
		WHERE  RES_CODE = @RES_CODE;	
	END
			
	BEGIN TRAN
	BEGIN TRY
			
		-- 고객 포인트 테이블에 사용내역을 저장한다.
		INSERT INTO DBO.CUS_POINT (CUS_NO, POINT_TYPE, ACC_USE_TYPE, POINT_PRICE, RES_CODE, TITLE, TOTAL_PRICE, REMARK, NEW_CODE, NEW_DATE)
		VALUES (@CUS_NO, 2, @USE_TYPE, @USE_POINT_PRICE, CASE @USE_TYPE WHEN 1 THEN @RES_CODE ELSE NULL END, @TITLE, @TOTAL_POINT - @USE_POINT_PRICE, @REMARK, @NEW_CODE, GETDATE())

		SELECT @POINT_NO = @@IDENTITY
			
		-- 변수 테이블 선언
		DECLARE @POINT_UPDATE TABLE
				(ACC_POINT_NO INT ,REMAIN_POINT_PRICE MONEY ,END_DATE DATETIME ,NEW_DATE DATETIME ,ACC_TYPE INT, REMAIN_DAYS INT)
			
			
		-- 사용자의 포인트 중 사용 포인트을 제외하고 남은 포인트 리스트를 변수 테이블에 저장
		-- 2011-12-07 포인트 사용취소(환불) 내역 제외하고 넣기
		INSERT @POINT_UPDATE
		SELECT TBL.POINT_NO, TBL.REMAIN_POINT_PRICE, TBL.END_DATE,
				TBL.NEW_DATE, TBL.ACC_TYPE, REMAIN_DAYS
		FROM   (
				    SELECT A.POINT_NO
				            ,A.POINT_PRICE - ISNULL(SUM(B.POINT_PRICE) ,0) AS REMAIN_POINT_PRICE
				            ,A.END_DATE
				            ,A.NEW_DATE
				            ,DBO.XN_CUS_POINT_TOP_ACC_CODE(A.POINT_NO) AS ACC_TYPE
				            ,MAX(DATEDIFF(DAY ,[START_DATE] ,END_DATE)) AS REMAIN_DAYS
				    FROM   DBO.CUS_POINT A WITH(NOLOCK)
				            LEFT JOIN DBO.CUS_POINT_HISTORY B WITH(NOLOCK)
				                ON  A.POINT_NO = B.ACC_POINT_NO
				    WHERE  A.POINT_TYPE = 1
				            AND A.CUS_NO = @CUS_NO
				            AND A.IS_CXL = 0 --사용취소 아닌것만
				    GROUP BY
				            A.POINT_NO
				            ,A.POINT_PRICE
				            ,A.END_DATE
				            ,A.NEW_DATE
				            ,A.ACC_USE_TYPE
				            ,A.ORG_POINT_NO
				) TBL
		WHERE  ABS(TBL.REMAIN_POINT_PRICE) > 0 -- 마이너스 적립도 포함
			
				
		-- 커서 변수 선언 및 변수 테이블에서 커서 데이터 추출
		DECLARE CRS_POINT_LIST CURSOR FOR
				
			SELECT ACC_POINT_NO, REMAIN_POINT_PRICE , ACC_TYPE 
			FROM @POINT_UPDATE
			WHERE REMAIN_POINT_PRICE > 0
			ORDER BY (CASE WHEN @TARGET_POINT_NO > 0 AND @TARGET_POINT_NO = ACC_POINT_NO THEN 0 ELSE 1 END ), --  우선적으로 차감 되어야 할 POINT_NO 우선
				REMAIN_DAYS ASC, END_DATE ASC, NEW_DATE ASC

		-- 선언한 커서 변수를 명시적으로 오픈
		OPEN CRS_POINT_LIST

		-- FETCH를 이용해서 레코드 추출
		FETCH NEXT FROM CRS_POINT_LIST INTO @ACC_POINT_NO, @REMAIN_POINT_PRICE , @ACC_TYPE 

		-- WHILE문으로 레코드 값 출력
		-- @@FETCH_STATUS : 0 = 성공, -1 = 실패(커서위치 잘못), -2 = 실패 (레코드 없음)
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- 사용 포인트를 계산하기 전 기존 포인트를 변수에 담아 둔다
			SET @BEFORE_POINT_PRICE = @USE_POINT_PRICE
					
			-- 포인트가 남은 포인트 번호에 해당하는 다음 포인트 사용 순번을 가져온다
			SELECT @SEQ_NO = ISNULL(MAX(SEQ_NO) + 1, 1)
			FROM DBO.CUS_POINT_HISTORY
			WHERE POINT_NO = @POINT_NO

			-- 포인트가 남은 포인트 번호에 해당하는 포인트 중 사용 포인트를 제외하고 남은 포인트를 변수에 담는다
			SELECT @USE_POINT_PRICE = (@USE_POINT_PRICE - @REMAIN_POINT_PRICE)
			FROM @POINT_UPDATE
			WHERE ACC_POINT_NO = @ACC_POINT_NO
					
			-- 커서를 돌며 사용자의 사용포인트 상세내역을 '포인트 사용 상세내역' 테이블에 저장한다
			INSERT INTO DBO.CUS_POINT_HISTORY (POINT_NO, SEQ_NO, ACC_POINT_NO, 
				POINT_PRICE, 
				NEW_CODE, NEW_DATE , ACC_TYPE)
			VALUES (@POINT_NO, @SEQ_NO, @ACC_POINT_NO, 
				CASE WHEN @USE_POINT_PRICE <= 0 THEN @BEFORE_POINT_PRICE ELSE @REMAIN_POINT_PRICE END, 
				@NEW_CODE, GETDATE() , @ACC_TYPE)
					
			-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				ROLLBACK TRAN;	
				CLOSE CRS_POINT_LIST
				DEALLOCATE CRS_POINT_LIST;		
				RETURN;
			END

			IF @USE_POINT_PRICE > 0
			BEGIN
				-- 커서를 다음칸으로 이동 (이 구문을 빼먹으면 무한 루프에 빠진다)
				FETCH NEXT FROM CRS_POINT_LIST INTO @ACC_POINT_NO, @REMAIN_POINT_PRICE, @ACC_TYPE 	
			END
			ELSE
			BEGIN
				-- 커서 반복 구문에서 빠져나와 해당 구문으로 이동한다
				GOTO CLOSE_CORSOR	
			END
		END
				
		-- GOTO 별칭 구문
		CLOSE_CORSOR:
				
		-- 커서닫기
		CLOSE CRS_POINT_LIST
		DEALLOCATE CRS_POINT_LIST;
			
		-------------------------------------------------------------------------------------
		-- 입금 테이블에 포인트 결제 내역 저장  20111208
		-- 예) 일반포인트 사용 시는 입금데이터 등록, 포인트 소멸 시 는 입출금 등록 없이 사용처리
		IF( @IS_PAYMENT = 1 )
		BEGIN
			--사용 포인트의 적립타입에 따른 SUB_TYPE 넣기 
			DECLARE @TMP_PAYLIST TABLE (ID INT IDENTITY(1 ,1) ,PAY_ACC_TYPE INT ,POINT_PRICE INT)
				
			-- 사용계정별로 그룹핑	
			INSERT INTO @TMP_PAYLIST (PAY_ACC_TYPE, POINT_PRICE)
			SELECT ACC_TYPE , SUM(POINT_PRICE)
			FROM (
				--SELECT (CASE WHEN ACC_TYPE IN (1, 2, 5, 9) THEN 71 ELSE 7 END) AS ACC_TYPE	-- 구매실적_적립 71, 회원가입_적립 7 (PaymentTypeEnum)
				SELECT (CASE WHEN ACC_TYPE IN (1, 2, 9) THEN 71 ELSE 7 END) AS ACC_TYPE			-- 구매실적_적립 71, 회원가입_적립 7 (PaymentTypeEnum)
					    ,POINT_PRICE
				FROM   CUS_POINT_HISTORY
				WHERE  POINT_NO = @POINT_NO 
			) TBL
			GROUP BY ACC_TYPE -- 적립타입별 분리해서 등록 
					
			-- 변수 선언
			DECLARE @CUS_NAME VARCHAR(40)
					
			-- 고객 고유번호로 고객명을 가져온다.
			SELECT @CUS_NAME = CUS_NAME FROM VIEW_MEMBER WHERE CUS_NO = @CUS_NO -- 휴면회원 조회를 위해 VIEW_MEMBER에서 조회
				
									
			DECLARE @LOOP_CNT INT = 1, @PAY_TYPE INT, @PAY_POINT_PRICE INT
				
			WHILE (SELECT MAX(ID) FROM @TMP_PAYLIST ) + 1 > @LOOP_CNT 
			BEGIN
					
				SELECT @PAY_TYPE = PAY_ACC_TYPE
					    ,@PAY_POINT_PRICE = POINT_PRICE
				FROM   @TMP_PAYLIST
				WHERE  ID = @LOOP_CNT 
					
				-- 입금 마스터 테이블에 포인트 결제 내역 저장
				INSERT INTO DBO.PAY_MASTER_DAMO (PAY_TYPE, PAY_METHOD, PAY_NAME, PAY_PRICE, PAY_DATE, CUS_NO, NEW_CODE, NEW_DATE)
				VALUES (@PAY_TYPE, 0, @CUS_NAME, @PAY_POINT_PRICE, GETDATE(), @CUS_NO, '9999999', GETDATE())
					
				-- 입금매칭 테이블에 포인트 결제 내역 저장
				INSERT INTO DBO.PAY_MATCHING (PAY_SEQ, MCH_SEQ, MCH_TYPE, RES_CODE, PRO_CODE, PART_PRICE, NEW_DATE, NEW_CODE)
				VALUES (@@IDENTITY, 1, 0, @RES_CODE, @PRO_CODE, @PAY_POINT_PRICE, GETDATE(), '9999999')
						
				SET @LOOP_CNT = @LOOP_CNT + 1 
			END
				
			-- 총판매가, 입금가 체크
			DECLARE @GET_PAY_PRICE DECIMAL, @TOTAL_PRICE DECIMAL
			SELECT @TOTAL_PRICE = DBO.FN_RES_GET_TOTAL_PRICE(@RES_CODE)
				    ,@GET_PAY_PRICE = DBO.FN_RES_GET_PAY_PRICE(@RES_CODE)

			IF @GET_PAY_PRICE >= @TOTAL_PRICE
				UPDATE RES_MASTER_DAMO SET RES_STATE = 4 WHERE RES_CODE = @RES_CODE  --결제완료로
			--ELSE IF @GET_PAY_PRICE > 0
			--	UPDATE RES_MASTER_DAMO SET RES_STATE = 3 WHERE RES_CODE = @RES_CODE
					
		END
		-------------------------------------------------------------------------------------
			
		IF @@TRANCOUNT > 0
		BEGIN
			COMMIT TRAN; 
		END
	END TRY
	BEGIN CATCH
	
		-- 에러로그
		INSERT INTO VGLog.dbo.SYS_ERP_LOG(
			LOG_TYPE,
			CATEGORY,
			EMP_CODE,
			TITLE, 
			BODY, 
			REQUEST, 
			TRACE)
		VALUES(
			1,				-- LogTypeEnum { None = 0, Error, Warning, Information };
			'AIR',
			@NEW_CODE,
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			('CUS_NO:' + CONVERT(VARCHAR(10), @CUS_NO) + ', RES_CODE:' + @RES_CODE),
			ERROR_LINE());
	
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN;
		END
	END CATCH
		
END
GO
