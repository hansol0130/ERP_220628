USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_PRO_TRANS_SEAT_TIME_UPDATE_MONTH  
■ Description				: 좌석 시간 일괄 수정   (특정일)
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 



■ Author					: 박형만  
■ Date						: 2019-04-01
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2019-04-01		박형만			최초생성  
   2019-04-18		박형만			대표시간 수정, 세그 날짜 복사 안되는 현상 수정 
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[SP_PRO_TRANS_SEAT_TIME_UPDATE_MONTH]
	@SEAT_CODE		INT,			-- 좌석코드
	@DAYS			VARCHAR(1000),	-- 일자들
	@EMP_CODE		CHAR(7),		-- 생성인코드
	
	@DEP_SPEND_TIME VARCHAR(5),
	@ARR_SPEND_TIME VARCHAR(5),

	@SEGXML XML = NULL 
AS
BEGIN
	SET NOCOUNT ON;

	-- 세그정보 XML 
	CREATE TABLE #TMP_SEG ( 
		SEAT_CODE	int,
		TRANS_SEQ	int,
		SEG_NO	int,
		DEP_AIRPORT_CODE	CHAR(3),
		ARR_AIRPORT_CODE	CHAR(3),
		AIRLINE_CODE	CHAR(2),
		FLIGHT	varchar(20),
		DEP_DATE	datetime,
		ARR_DATE	datetime,
		REAL_AIRLINE_CODE	varchar(2),
		FLYING_TIME	varchar(5) )

	INSERT INTO #TMP_SEG
	SELECT 
	t1.col.value ( './SeatCode[1]' ,'int') AS SEAT_CODE ,
	t1.col.value ( './TransSeq[1]' ,'int') AS TRANS_SEQ,
	t1.col.value ( './SegNo[1]' ,'int') AS SEG_NO,
	t1.col.value ( './DepartureAirportCode[1]' ,'varchar(3)') AS DEP_AIRPORT_CODE,
	t1.col.value ( './ArrivalAirportCode[1]' ,'varchar(3)') AS ARR_AIRPORT_CODE,
	t1.col.value ( './AirlineCode[1]' ,'varchar(2)') AS AIRLINE_CODE,
	t1.col.value ( './FlightNo[1]' ,'varchar(5)') AS FLIGHT,
	t1.col.value ( './DepartureDate[1]' ,'datetime') AS DEP_DATE,
	t1.col.value ( './ArrivalDate[1]' ,'datetime') AS ARR_DATE,
	t1.col.value ( './RealAirlineCode[1]' ,'varchar(2)') AS REAL_AIRLINE_CODE,
	t1.col.value ( './FlyingTime[1]' ,'varchar(5)') AS FLYING_TIME
	FROM @SEGXML.nodes('/ArrayOfTransSeatSegRQ/TransSeatSegRQ') AS t1(col)	

	
	DECLARE @DIFF_DAY INT, @DEP_DIFF INT, @ARR_DIFF INT
	DECLARE @DEP_DEP_TIME VARCHAR(5),@DEP_ARR_TIME VARCHAR(5),@ARR_DEP_TIME VARCHAR(5),@ARR_ARR_TIME VARCHAR(5)
	DECLARE @DEP_SPEND VARCHAR(5), @ARR_SPEND VARCHAR(5), @DEP_MINUTE INT, @ARR_MINUTE INT
	DECLARE @NEW_SEAT_CODE INT, @DAY VARCHAR(10), @STRIKE INT, @CONTINUE INT
	DECLARE @FIRST CHAR(1)

	-- 디폴트
	SET @CONTINUE = 1
	--SET @FIRST = '1'								-- 최초 체크
	
	DECLARE @BASE_DEP_DATE DATETIME -- 기준 출국편 시작 날짜 
	DECLARE @BASE_ARR_DATE DATETIME -- 기준 귀국편 시작 날짜 

	SELECT
		@DIFF_DAY = DATEDIFF(DAY, DEP_DEP_DATE, ARR_DEP_DATE)
		, @DEP_DIFF = DATEDIFF(DAY, DEP_DEP_DATE, DEP_ARR_DATE)
		, @ARR_DIFF = DATEDIFF(DAY, DEP_DEP_DATE, ARR_ARR_DATE)
		--, @DEP_MINUTE = DATEDIFF(MI, (CONVERT(VARCHAR(10), DEP_DEP_DATE, 120) + ' ' + @DEP_DEP_TIME)
		--	, (CONVERT(VARCHAR(10), DEP_ARR_DATE, 120) + ' ' + @DEP_ARR_TIME))
		--, @ARR_MINUTE = DATEDIFF(MI, (CONVERT(VARCHAR(10), ARR_DEP_DATE, 120) + ' ' + @ARR_DEP_TIME)
		--	, (CONVERT(VARCHAR(10), ARR_ARR_DATE, 120) + ' ' + @ARR_ARR_TIME))
		,@BASE_DEP_DATE = DEP_DEP_DATE 
		,@BASE_ARR_DATE = ARR_DEP_DATE 
	FROM PRO_TRANS_SEAT  WITH(NOLOCK) WHERE SEAT_CODE = @SEAT_CODE
	
	-- 소요시간  2019-04-09 주석처리 
	--SELECT @DEP_SPEND = RIGHT('0' + CONVERT(VARCHAR(2), (@DEP_MINUTE / 60)), 2) + ':' + RIGHT('0' + CONVERT(VARCHAR(2), (@DEP_MINUTE % 60)), 2)
	--	, @ARR_SPEND = RIGHT('0' + CONVERT(VARCHAR(2), (@ARR_MINUTE / 60)), 2) + ':' + RIGHT('0' + CONVERT(VARCHAR(2), (@ARR_MINUTE % 60)), 2)
	
	--2019-04-18 수정처리 
	---- 세그 정보로 좌석전체 넣음 
	----SELECT * FROM #TMP_SEG
	--SELECT @DEP_DEP_TIME = SUBSTRING(CONVERT(VARCHAR(16),MIN(DEP_DATE),121),12,5) ,
	--@DEP_ARR_TIME = SUBSTRING(CONVERT(VARCHAR(16),MAX(ARR_DATE),121),12,5)   FROM #TMP_SEG  WHERE TRANS_SEQ = 1  --출국

	--SELECT @ARR_DEP_TIME = SUBSTRING(CONVERT(VARCHAR(16),MIN(DEP_DATE),121),12,5) ,
	--@ARR_ARR_TIME = SUBSTRING(CONVERT(VARCHAR(16),MAX(ARR_DATE),121),12,5)   FROM #TMP_SEG  WHERE TRANS_SEQ = 2  --귀국
	
	
	-- 시간은 전체 일자 공통 
	SELECT 	@DEP_DEP_TIME = SUBSTRING(CONVERT(VARCHAR(16),(SELECT TOP 1 DEP_DATE  FROM #TMP_SEG  WHERE TRANS_SEQ = 1 ORDER BY SEG_NO ASC),121),12,5)  --출국 첫번째의 출발 
	SELECT 	@DEP_ARR_TIME = SUBSTRING(CONVERT(VARCHAR(16),(SELECT TOP 1 ARR_DATE  FROM #TMP_SEG  WHERE TRANS_SEQ = 1 ORDER BY SEG_NO DESC),121),12,5) --출국 마지막의 도착

	SELECT 	@ARR_DEP_TIME = SUBSTRING(CONVERT(VARCHAR(16),(SELECT TOP 1 DEP_DATE  FROM #TMP_SEG  WHERE TRANS_SEQ = 2 ORDER BY SEG_NO ASC),121),12,5)  --귀국 첫번째의 출발 
	SELECT 	@ARR_ARR_TIME = SUBSTRING(CONVERT(VARCHAR(16),(SELECT TOP 1 ARR_DATE  FROM #TMP_SEG  WHERE TRANS_SEQ = 2 ORDER BY SEG_NO DESC),121),12,5) --귀국 마지막의 도착

	-- 입력된 값으로 수정 
	SET @DEP_SPEND = @DEP_SPEND_TIME
	SET @ARR_SPEND = @ARR_SPEND_TIME

	CREATE TABLE #MSG_TEMP (
		[ERROR_SEQ] INT IDENTITY,	[ERROR_DATE] DATETIME,
		[ERROR_TYPE] INT,			[ERROR_MESSAGE] NVARCHAR(2048))

	-- 선택좌석(기준좌석) 도 수정
	DECLARE @BASE_SEAT_UPDATE_YN CHAR(1)  -- 수정여부 
	SET @BASE_SEAT_UPDATE_YN = 'N'
	---------------------------------------------------
	BEGIN TRY
		BEGIN TRAN 

		UPDATE PRO_TRANS_SEAT SET
			DEP_DEP_TIME = @DEP_DEP_TIME, DEP_ARR_TIME = @DEP_ARR_TIME, DEP_SPEND_TIME = @DEP_SPEND
			, ARR_DEP_TIME = @ARR_DEP_TIME, ARR_ARR_TIME = @ARR_ARR_TIME, ARR_SPEND_TIME = @ARR_SPEND
			, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
		WHERE SEAT_CODE = @SEAT_CODE

------ 임시 오류 
--DECLARE @A INT 
--SET @A = 1/0 
		-- 상세세그 관련 수정 
		-- 상세세그 없거나 , 갯수가 같지 않을때 갱신 
		IF NOT EXISTS (SELECT * FROM PRO_TRANS_SEAT_SEGMENT 
			WHERE SEAT_CODE = @SEAT_CODE) 
			OR (SELECT COUNT(*) FROM PRO_TRANS_SEAT_SEGMENT 
				WHERE SEAT_CODE = @SEAT_CODE ) <> (SELECT COUNT(*) #TMP_SEG )
		BEGIN
			-- 삭제후 
			DELETE PRO_TRANS_SEAT_SEGMENT 
			WHERE SEAT_CODE = @SEAT_CODE  
			-- 상세세그 없거나 같지 않으면 재입력해준다 
			INSERT PRO_TRANS_SEAT_SEGMENT 
			(SEAT_CODE,TRANS_SEQ,SEG_NO,DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,FLIGHT,
			DEP_DATE,ARR_DATE,NEW_CODE,NEW_DATE,REAL_AIRLINE_CODE,FLYING_TIME)
			SELECT 
			SEAT_CODE ,
			TRANS_SEQ,SEG_NO,DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,FLIGHT,
			DEP_DATE,ARR_DATE,@EMP_CODE,GETDATE(),REAL_AIRLINE_CODE,FLYING_TIME 
			FROM #TMP_SEG A 
		END 
		ELSE
		BEGIN
			-- 시간관련 업데이트 
			UPDATE A 
			SET A.DEP_DATE = B.DEP_DATE 
				,A.ARR_DATE = B.ARR_DATE 
				,A.FLYING_TIME = B.FLYING_TIME
				,A.EDT_CODE = @EMP_CODE 
				,A.EDT_DATE = GETDATE() 
			FROM PRO_TRANS_SEAT_SEGMENT A 
				INNER JOIN #TMP_SEG B 
					ON A.TRANS_SEQ = B.TRANS_SEQ 
					AND A.SEG_NO = B.SEG_NO 
			WHERE A.SEAT_CODE = @SEAT_CODE						
		END 

					
		INSERT INTO #MSG_TEMP 
		SELECT (SELECT TOP 1 DEP_DEP_DATE FROM PRO_TRANS_SEAT WHERE SEAT_CODE = @SEAT_CODE ), 1, '성공'
					
		COMMIT TRAN 
						
		SET @BASE_SEAT_UPDATE_YN = 'Y' -- 수정완료 
						

	END TRY
	BEGIN CATCH
		ROLLBACK TRAN 
						
		INSERT INTO #MSG_TEMP 
		SELECT  (SELECT TOP 1 DEP_DEP_DATE FROM PRO_TRANS_SEAT WHERE SEAT_CODE = @SEAT_CODE ) , 2, '기준좌석수정오류:'+ ERROR_MESSAGE()

	END CATCH 
	
	---------------------------------------------------
	-- 기준 좌석 수정성공시에만 
	IF @BASE_SEAT_UPDATE_YN = 'Y' 
	BEGIN
		
		-- 대상 좌석 조회 
		DECLARE @TARGET_SEAT_CODE  TABLE ( SEAT_CODE INT ) 

		----- 루프 시작 -----
		WHILE @CONTINUE = 1
		BEGIN
			IF CHARINDEX('|', @DAYS) > 0
			BEGIN
				SET @DAY = SUBSTRING(@DAYS, 1, CHARINDEX('|', @DAYS) - 1)

				BEGIN TRY
					--SET @NEW_SEAT_CODE = 0
				
					-- 테이블 변수 지우기 
					DELETE FROM @TARGET_SEAT_CODE
				
					--2019-04-09 비즈니스 좌석 추가로 해당 좌석코드 전체 업데이트 
					-- 해당일자에 좌석이 있는지 체크
					INSERT INTO @TARGET_SEAT_CODE
					SELECT B.SEAT_CODE FROM PRO_TRANS_SEAT A WITH(NOLOCK) 
						INNER JOIN PRO_TRANS_SEAT B  WITH(NOLOCK) ON A.DEP_TRANS_CODE = B.DEP_TRANS_CODE AND A.DEP_TRANS_NUMBER = B.DEP_TRANS_NUMBER
							AND A.DEP_DEP_AIRPORT_CODE = B.DEP_DEP_AIRPORT_CODE AND A.DEP_ARR_AIRPORT_CODE = B.DEP_ARR_AIRPORT_CODE
							AND A.ARR_TRANS_CODE = B.ARR_TRANS_CODE AND A.ARR_TRANS_NUMBER = B.ARR_TRANS_NUMBER
							AND A.ARR_DEP_AIRPORT_CODE = B.ARR_DEP_AIRPORT_CODE AND A.ARR_ARR_AIRPORT_CODE = B.ARR_ARR_AIRPORT_CODE
						WHERE A.SEAT_CODE = @SEAT_CODE
							AND B.DEP_DEP_DATE = @DAY AND B.DEP_ARR_DATE = DATEADD(DAY, @DEP_DIFF, @DAY)
							AND B.ARR_DEP_DATE = DATEADD(DAY, @DIFF_DAY, @DAY) AND B.ARR_ARR_DATE = DATEADD(DAY, @ARR_DIFF, @DAY)

					-- 해당일자에 좌석이 있는지 체크
					IF EXISTS ( SELECT * FROM @TARGET_SEAT_CODE ) 
					--IF @NEW_SEAT_CODE > 0
					BEGIN

						-- 각 세그 복사시 날짜 차이 계산 2019-04-18
						DECLARE @DIFF_DATE_DAY INT 
						SET @DIFF_DATE_DAY = DATEDIFF(DAY,@BASE_DEP_DATE,@DAY)
						
						--SELECT @DIFF_DEP_SEG_DAY , @DIFF_ARR_SEG_DAY 

						-- 기준좌석과 차이가 없고 중복좌석코드가 (일반석,비즈니스) 가 하나일때만 
						IF @DIFF_DATE_DAY = 0  AND (SELECT COUNT(*) FROM @TARGET_SEAT_CODE ) = 1 
						BEGIN
							INSERT INTO #MSG_TEMP 
							SELECT @DAY, 2, '기준좌석 이미수정됨'

							SET @STRIKE = LEN(@DAY) + 1
							SET @DAYS = LTRIM(RIGHT(@DAYS, LEN(@DAYS) - @STRIKE))  -- NEXT 
							
							CONTINUE -- 처음
						END  

						---------------------------------------------------
						BEGIN TRY
							BEGIN TRAN 

							--좌석업데이트 
							UPDATE PRO_TRANS_SEAT SET
								DEP_DEP_TIME = @DEP_DEP_TIME, DEP_ARR_TIME = @DEP_ARR_TIME, DEP_SPEND_TIME = @DEP_SPEND
								, ARR_DEP_TIME = @ARR_DEP_TIME, ARR_ARR_TIME = @ARR_ARR_TIME, ARR_SPEND_TIME = @ARR_SPEND
								, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
							WHERE SEAT_CODE IN ( SELECT SEAT_CODE FROM @TARGET_SEAT_CODE )
			-------- 임시 오류 
			--DECLARE @A INT 
			--SET @A = 1/0 
							-- 날짜 차이 계산 2019-04-18
							DECLARE @DIFF_DEP_SEG_DAY INT 
							DECLARE @DIFF_ARR_SEG_DAY INT 
							SET @DIFF_DEP_SEG_DAY = DATEDIFF(DAY,@BASE_DEP_DATE,@DAY)
							SET @DIFF_ARR_SEG_DAY = DATEDIFF(DAY,@BASE_ARR_DATE,@DAY)
							--SELECT DATEDIFF(DAY,'2019-05-30','2019-05-31')

							-- 상세세그 관련 수정 
							-- 상세세그 없거나 , 갯수가 같지 않을때 갱신 
							IF NOT EXISTS (
								SELECT * FROM PRO_TRANS_SEAT_SEGMENT 
								WHERE SEAT_CODE IN ( SELECT SEAT_CODE FROM @TARGET_SEAT_CODE ) )
								OR (SELECT COUNT(*) FROM PRO_TRANS_SEAT_SEGMENT 
									WHERE SEAT_CODE IN ( SELECT SEAT_CODE FROM @TARGET_SEAT_CODE ) ) <> (SELECT COUNT(*) FROM #TMP_SEG A CROSS JOIN @TARGET_SEAT_CODE )
							BEGIN
								-- 삭제후 
								DELETE PRO_TRANS_SEAT_SEGMENT 
								WHERE SEAT_CODE IN ( SELECT SEAT_CODE FROM @TARGET_SEAT_CODE )

								-- 상세세그 없거나 같지 않으면 재입력해준다 
								INSERT PRO_TRANS_SEAT_SEGMENT 
								(SEAT_CODE,TRANS_SEQ,SEG_NO,DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,FLIGHT,
								DEP_DATE,ARR_DATE,
								NEW_CODE,NEW_DATE,REAL_AIRLINE_CODE,FLYING_TIME)
								SELECT 
								B.SEAT_CODE ,
								TRANS_SEQ,SEG_NO,DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,FLIGHT,
								DATEADD(DAY, @DIFF_DATE_DAY, A.DEP_DATE),	-- 세그출발시각, 기준날짜와의 차이만큼 + 
								DATEADD(DAY, @DIFF_DATE_DAY, A.ARR_DATE),  	-- 세그도착시각, 기준날짜와의 차이만큼 + 
								--DEP_DATE,ARR_DATE,
								@EMP_CODE,GETDATE(),REAL_AIRLINE_CODE,FLYING_TIME 
								FROM #TMP_SEG A 
								CROSS JOIN @TARGET_SEAT_CODE B
							END 
							ELSE
							BEGIN
								-- 시간관련 업데이트 
								UPDATE A 
								SET A.DEP_DATE = DATEADD(DAY, @DIFF_DATE_DAY, B.DEP_DATE)	-- 세그출발시각, 기준날짜와의 차이만큼 + 
									,A.ARR_DATE = DATEADD(DAY, @DIFF_DATE_DAY, B.ARR_DATE)	-- 세그도착시각, 기준날짜와의 차이만큼 + 
									,A.FLYING_TIME = B.FLYING_TIME
									,A.EDT_CODE = @EMP_CODE 
									,A.EDT_DATE = GETDATE() 
								FROM PRO_TRANS_SEAT_SEGMENT A 
									INNER JOIN #TMP_SEG B 
										ON A.TRANS_SEQ = B.TRANS_SEQ 
										AND A.SEG_NO = B.SEG_NO 
								WHERE A.SEAT_CODE IN ( SELECT SEAT_CODE FROM @TARGET_SEAT_CODE )  
							END 
					
							INSERT INTO #MSG_TEMP 
							SELECT @DAY, 1, '성공'
							
							COMMIT TRAN 

						END TRY
						BEGIN CATCH
							ROLLBACK TRAN 

							INSERT INTO #MSG_TEMP 
							SELECT @DAY, 2, '좌석수정오류:'+ ERROR_MESSAGE()

						END CATCH
						--------------------------------------------------- 
					END
					ELSE
					BEGIN
						INSERT INTO #MSG_TEMP 
						SELECT @DAY, 2, '좌석정보없음'
					END

				END TRY
				BEGIN CATCH
					-- LOG INSERT
					INSERT INTO #MSG_TEMP 
					SELECT @DAY, 2, ERROR_MESSAGE()
				END CATCH
			
				-- 일자변경
				SET @STRIKE = LEN(@DAY) + 1
				SET @DAYS = LTRIM(RIGHT(@DAYS, LEN(@DAYS) - @STRIKE))
			END
			ELSE
			BEGIN
				SET @CONTINUE = 0
			END
		END
		----- 루프 끝-----
	

	END 

	-- 처리결과 SELECT 
	SELECT * FROM #MSG_TEMP
	
	DROP TABLE #MSG_TEMP
END


GO
