USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_CUS_POINT_TRANSFER_INSERT  
■ Description				: 사용자 포인트 양도 저장
■ Input Parameter			:                  
		@ACC_CUS_NO			: 양수자 고객 고유번호
		@USE_CUS_NO			: 양도자 고객 고유번호
		@USE_POINT_PRICE	: 사용 포인트
		@NEW_CODE			: 작성자 코드
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_CUS_POINT_TRANSFER_INSERT  
■ Author					: 임형민  
■ Date						: 2010-05-17  
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2010-05-17       임형민			최초생성  
   2010-12-08		김성호			회원테이블 분리
   2012-01-18		박형만			양도 내역 입력 버그 수정
   2012-02-16		박형만			양도 적립시 최초 포인트 적립 ORG_POINT_NO 입력  
   2016-04-18		박형만			TOTAL_POINT(남은포인트) 가져올때 NEW_DATE DESC 정렬시 버그 발생,POINT_NO DESC 로 수정 
   2017-09-13		박형만			양수자 휴면회원 정보 버그수정  @ACC_CUS_ID -> @USE_CUS_ID
   2020-09-02		김성호			쿼리 정리 (불필요 부분 삭제) (TA서버 백업 저장 [SP_CUS_POINT_TRANSFER_INSERT_BACKUP])
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_CUS_POINT_TRANSFER_INSERT]
(	
	@ACC_CUS_NO					INT,					-- 기준 회원번호		(양수자)
	@USE_CUS_NO					INT,					-- 병합될 회원번호	(양도자)
	@USE_POINT_PRICE			MONEY,
	@TITLE						VARCHAR(100)			= '',
	@NEW_CODE					CHAR(7)					= '9999999'
)

AS
	BEGIN
	
----exec sp_executesql N'EXEC SP_CUS_POINT_TRANSFER_INSERT @ACC_CUS_NO,@USE_CUS_NO,@USE_POINT_PRICE,@TITLE,@NEW_CODE'
----,N'@ACC_CUS_NO int,@USE_CUS_NO int,@USE_POINT_PRICE int,@TITLE nvarchar(9),@NEW_CODE nvarchar(7)'
--DECLARE @ACC_CUS_NO					INT,
--	@USE_CUS_NO					INT,
--	@USE_POINT_PRICE			MONEY,
--	@TITLE						VARCHAR(100)		 ,
--	@NEW_CODE					CHAR(7)					 

--SELECT @ACC_CUS_NO=4284582
--,@USE_CUS_NO=4228549
--,@USE_POINT_PRICE=1000
--,@TITLE=N'포인트 양도 적립'
--,@NEW_CODE=N'9999999'
	
		-- 변수 선언
		
		DECLARE @POINT_NO INT, @ACC_POINT_NO INT
		DECLARE @ACC_CUS_ID VARCHAR(20), @USE_CUS_ID VARCHAR(20)
		DECLARE @ACC_CUS_NAME VARCHAR(20), @USE_CUS_NAME VARCHAR(20)
		DECLARE @TOTAL_POINT1 MONEY, @TOTAL_POINT2 MONEY, @REMAIN_POINT_PRICE MONEY, @BEFORE_POINT_PRICE MONEY
		DECLARE @ERROR1 INT, @ERROR2 INT, @ERROR3 INT, @ROWCNT1 INT, @ROWCNT2 INT, @ROWCNT3 INT
			
		BEGIN TRAN
			
			-- 양수자 정보
			SELECT @ACC_CUS_ID = ISNULL(A.CUS_ID, B.CUS_ID), @ACC_CUS_NAME = ISNULL(A.CUS_NAME, B.CUS_NAME)
			FROM CUS_MEMBER A WITH(NOLOCK)
			LEFT JOIN CUS_MEMBER_SLEEP B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO 
			WHERE A.CUS_NO = @ACC_CUS_NO
			
			-- 양도자 정보
			SELECT @USE_CUS_ID = ISNULL(A.CUS_ID, B.CUS_ID), @USE_CUS_NAME = ISNULL(A.CUS_NAME, B.CUS_NAME)
			FROM CUS_MEMBER A WITH(NOLOCK)
			LEFT JOIN CUS_MEMBER_SLEEP B WITH(NOLOCK) ON A.CUS_NO = B.CUS_NO 
			WHERE A.CUS_NO = @USE_CUS_NO
			
			
			-- 양도자 포인트 내역 테이블 선언
			DECLARE @POINT_UPDATE TABLE
			(
				ACC_POINT_NO					INT,
				REMAIN_POINT_PRICE				MONEY,
				END_DATE						DATETIME,
				NEW_DATE						DATETIME
			)

			-- 사용자의 포인트 중 사용 포인트을 제외하고 남은 포인트 리스트를 변수 테이블에 저장
			INSERT @POINT_UPDATE
			SELECT A.POINT_NO,
				   A.POINT_PRICE - ISNULL(SUM(B.POINT_PRICE), 0),
				   A.END_DATE,
				   A.NEW_DATE
			FROM DBO.CUS_POINT A
			LEFT JOIN DBO.CUS_POINT_HISTORY B ON A.POINT_NO = B.ACC_POINT_NO
			WHERE A.POINT_TYPE = 1
			  AND A.CUS_NO = @USE_CUS_NO
			GROUP BY A.POINT_NO, A.POINT_PRICE, A.END_DATE, A.NEW_DATE


			-- 커서 변수 선언 및 변수 테이블에서 커서 데이터 추출
			DECLARE CRS_POINT_LIST CURSOR FOR
			
				SELECT ACC_POINT_NO, REMAIN_POINT_PRICE
				FROM @POINT_UPDATE
				WHERE REMAIN_POINT_PRICE > 0
				ORDER BY END_DATE ASC, NEW_DATE ASC

			-- 선언한 커서 변수를 명시적으로 오픈
			OPEN CRS_POINT_LIST

			-- FETCH를 이용해서 레코드 추출
			FETCH NEXT FROM CRS_POINT_LIST INTO @ACC_POINT_NO, @REMAIN_POINT_PRICE

			-- WHILE문으로 레코드 값 출력
			-- @@FETCH_STATUS : 0 = 성공, -1 = 실패(커서위치 잘못), -2 = 실패 (레코드 없음)
			WHILE @@FETCH_STATUS = 0
			BEGIN
				
				SELECT @BEFORE_POINT_PRICE = @USE_POINT_PRICE		-- 양도 금액 백업
					, @TOTAL_POINT1 = ISNULL((						-- 양도자 현재 총 포인트 조회
						SELECT TOP 1 TOTAL_PRICE 
						FROM Diablo.DBO.CUS_POINT WITH(NOLOCK)
						WHERE CUS_NO = @USE_CUS_NO
						ORDER BY POINT_NO DESC), 0)
				
				-- 포인트가 남은 포인트 번호에 해당하는 포인트 중 사용 포인트를 제외하고 남은 포인트를 변수에 담는다
				SELECT @USE_POINT_PRICE = (@USE_POINT_PRICE - @REMAIN_POINT_PRICE)
				
				
				-- 양도자 포인트 테이블에 사용내역을 저장한다. (양도 차감)
				INSERT INTO DBO.CUS_POINT (CUS_NO, POINT_TYPE, ACC_USE_TYPE
					, POINT_PRICE
					, TITLE
					, TOTAL_PRICE
					, REMARK, NEW_CODE, NEW_DATE)
				SELECT CUS_NO, 2, 4
					, CASE WHEN @USE_POINT_PRICE <= 0 THEN @BEFORE_POINT_PRICE ELSE @REMAIN_POINT_PRICE END
					, @TITLE + '(' + @ACC_CUS_ID + '/' + @ACC_CUS_NAME + ')' 
					, CASE WHEN @USE_POINT_PRICE <= 0 THEN @TOTAL_POINT1 - @BEFORE_POINT_PRICE ELSE @TOTAL_POINT1 - @REMAIN_POINT_PRICE END
					, REMARK, @NEW_CODE, GETDATE()
				FROM DBO.CUS_POINT
				WHERE POINT_NO = @ACC_POINT_NO

				-- 포인트번호와 오류 개수, 적용 로우 개수를 가져온다
				SELECT @POINT_NO = @@IDENTITY, @ERROR1 = @@ERROR, @ROWCNT1 = @@ROWCOUNT
				
				-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
				IF @ERROR1 <> 0 AND @ROWCNT1 = 0
				BEGIN
					IF @@TRANCOUNT > 0
						ROLLBACK TRAN				
				END
				ELSE
				BEGIN
					
					-- 커서를 돌며 사용자의 사용포인트 상세내역을 '포인트 사용 상세내역' 테이블에 저장한다
					INSERT INTO DBO.CUS_POINT_HISTORY (POINT_NO, SEQ_NO, ACC_POINT_NO
						, POINT_PRICE, NEW_CODE, NEW_DATE)
					VALUES (@POINT_NO, 1, @ACC_POINT_NO
						, CASE WHEN @USE_POINT_PRICE <= 0 THEN @BEFORE_POINT_PRICE ELSE @REMAIN_POINT_PRICE END, @NEW_CODE, GETDATE())
					
					-- 오류 개수와 적용 로우 개수를 가져온다
					SELECT @ERROR2 = @@ERROR, @ROWCNT2 = @@ROWCOUNT
					
					-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
					IF @ERROR2 <> 0 AND @ROWCNT2 = 0
					BEGIN
						IF @@TRANCOUNT > 0
							ROLLBACK TRAN				
					END
					ELSE
					BEGIN
						
						-- 양수자 현재 총 포인트 조회
						SELECT @TOTAL_POINT2 = ISNULL((						
							SELECT TOP 1 TOTAL_PRICE 
							FROM Diablo.DBO.CUS_POINT WITH(NOLOCK)
							WHERE CUS_NO = @ACC_CUS_NO
							ORDER BY POINT_NO DESC), 0)

						-- 고객 포인트 테이블에 사용내역을 저장한다. (양도 적립)
						INSERT DBO.CUS_POINT(CUS_NO, POINT_TYPE, ACC_USE_TYPE,START_DATE, END_DATE
							, POINT_PRICE
							, RES_CODE ,TITLE
							, TOTAL_PRICE
							, MASTER_SEQ , BOARD_SEQ , REMARK , NEW_CODE, NEW_DATE 
							, ORG_POINT_NO )
						SELECT @ACC_CUS_NO, 1, 6, START_DATE, END_DATE
							, CASE WHEN @USE_POINT_PRICE <= 0 THEN @BEFORE_POINT_PRICE ELSE @REMAIN_POINT_PRICE END
							, NULL, (@TITLE + '(' + @USE_CUS_ID + '/' + @USE_CUS_NAME + ')')
							, (@TOTAL_POINT2 + (CASE WHEN @USE_POINT_PRICE <= 0 THEN @BEFORE_POINT_PRICE ELSE @REMAIN_POINT_PRICE END))
							, MASTER_SEQ, BOARD_SEQ, REMARK, @NEW_CODE, GETDATE()
							, POINT_NO -- 양도 적립시 원래 포인트 번호 입력 2012-02-16 추가 
						FROM DBO.CUS_POINT WITH(NOLOCK)
						WHERE POINT_NO = @ACC_POINT_NO

						-- 오류 개수와 적용 로우 개수를 가져온다
						SELECT @ERROR3 = @@ERROR, @ROWCNT3 = @@ROWCOUNT
						
						-- 오류사항이 있거나 적용이 하나도 안되었다면 ROLLBACK 한다
						IF @ERROR3 <> 0 AND @ROWCNT3 = 0
						BEGIN
							IF @@TRANCOUNT > 0
								ROLLBACK TRAN				
						END
					END

					IF @USE_POINT_PRICE > 0
					BEGIN
						-- 커서를 다음칸으로 이동 (이 구문을 빼먹으면 무한 루프에 빠진다)
						FETCH NEXT FROM CRS_POINT_LIST INTO @ACC_POINT_NO, @REMAIN_POINT_PRICE		
					END
					ELSE
					BEGIN
						-- 커서 반복 구문에서 빠져나와 해당 구문으로 이동한다
						GOTO CLOSE_CORSOR	
					END
				END
			END

			-- GOTO 별칭 구문
			CLOSE_CORSOR:
			
			-- 커서닫기
			CLOSE CRS_POINT_LIST

			-- 메모리 완전 해제
			DEALLOCATE CRS_POINT_LIST;

		IF @@TRANCOUNT > 0
			COMMIT TRAN
	END


GO
