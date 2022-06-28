USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_PRO_TRANS_SEAT_TIME_UPDATE  
■ Description				: 좌석 시간 일괄 수정  
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: 

declare @p5 xml
set @p5=convert(xml,N'<ArrayOfTransSeatSegRQ xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><TransSeatSegRQ><SeatCode>7124339</SeatCode><TransSeq>1</TransSeq><SegNo>1</SegNo><DepartureAirportCode>ICN</DepartureAirportCode><ArrivalAirportCode>CDG</ArrivalAirportCode><AirlineCode>KE</AirlineCode><FlightNo>901</FlightNo><DepartureDate>2019-04-19T13:05:00.000</DepartureDate><ArrivalDate>2019-04-19T18:30:00.000</ArrivalDate><NewCode>2013007</NewCode><NewDate>2019-04-19T14:07:04.890</NewDate><RealAirlineCode/><FlyingTime>12:25</FlyingTime></TransSeatSegRQ><TransSeatSegRQ><SeatCode>7124339</SeatCode><TransSeq>2</TransSeq><SegNo>1</SegNo><DepartureAirportCode>PRG</DepartureAirportCode><ArrivalAirportCode>AMS</ArrivalAirportCode><AirlineCode>KE</AirlineCode><FlightNo>7657</FlightNo><DepartureDate>2019-04-24T17:30:00.000</DepartureDate><ArrivalDate>2019-04-24T19:00:00.000</ArrivalDate><NewCode>2013007</NewCode><NewDate>2019-04-19T14:07:04.890</NewDate><RealAirlineCode>OK</RealAirlineCode><FlyingTime>01:30</FlyingTime></TransSeatSegRQ><TransSeatSegRQ><SeatCode>7124339</SeatCode><TransSeq>2</TransSeq><SegNo>2</SegNo><DepartureAirportCode>AMS</DepartureAirportCode><ArrivalAirportCode>ICN</ArrivalAirportCode><AirlineCode>KE</AirlineCode><FlightNo>5926</FlightNo><DepartureDate>2019-04-24T21:25:00.000</DepartureDate><ArrivalDate>2019-04-25T14:55:00.000</ArrivalDate><NewCode>2013007</NewCode><NewDate>2019-04-19T14:07:04.890</NewDate><RealAirlineCode>KL</RealAirlineCode><FlyingTime>10:30</FlyingTime></TransSeatSegRQ></ArrayOfTransSeatSegRQ>')
exec SP_PRO_TRANS_SEAT_TIME_UPDATE @SEAT_CODE=7124339,

@EMP_CODE='2013007',@DEP_SPEND_TIME=N'12:25',@ARR_SPEND_TIME=N'14:25',

@SEGXML=@p5,
@START=N'2019-04-19',
@END=N'2019-04-22',@WEEK_DAY_TYPE=N'1111111'




declare @p5 xml
set @p5=convert(xml,N'<ArrayOfTransSeatSegRQ xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><TransSeatSegRQ><SeatCode>7124339</SeatCode><TransSeq>1</TransSeq><SegNo>1</SegNo><DepartureAirportCode>ICN</DepartureAirportCode><ArrivalAirportCode>CDG</ArrivalAirportCode><AirlineCode>KE</AirlineCode><FlightNo>901</FlightNo><DepartureDate>2019-04-19T13:05:00.000</DepartureDate><ArrivalDate>2019-04-19T18:30:00.000</ArrivalDate><NewCode>2013007</NewCode><NewDate>2019-04-19T14:07:04.890</NewDate><RealAirlineCode/><FlyingTime>12:25</FlyingTime></TransSeatSegRQ><TransSeatSegRQ><SeatCode>7124339</SeatCode><TransSeq>2</TransSeq><SegNo>1</SegNo><DepartureAirportCode>PRG</DepartureAirportCode><ArrivalAirportCode>AMS</ArrivalAirportCode><AirlineCode>KE</AirlineCode><FlightNo>7657</FlightNo><DepartureDate>2019-04-24T17:30:00.000</DepartureDate><ArrivalDate>2019-04-24T19:00:00.000</ArrivalDate><NewCode>2013007</NewCode><NewDate>2019-04-19T14:07:04.890</NewDate><RealAirlineCode>OK</RealAirlineCode><FlyingTime>01:30</FlyingTime></TransSeatSegRQ><TransSeatSegRQ><SeatCode>7124339</SeatCode><TransSeq>2</TransSeq><SegNo>2</SegNo><DepartureAirportCode>AMS</DepartureAirportCode><ArrivalAirportCode>ICN</ArrivalAirportCode><AirlineCode>KE</AirlineCode><FlightNo>5926</FlightNo><DepartureDate>2019-04-24T21:25:00.000</DepartureDate><ArrivalDate>2019-04-25T14:55:00.000</ArrivalDate><NewCode>2013007</NewCode><NewDate>2019-04-19T14:07:04.890</NewDate><RealAirlineCode>KL</RealAirlineCode><FlyingTime>10:30</FlyingTime></TransSeatSegRQ></ArrayOfTransSeatSegRQ>')
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

	FROM @p5.nodes('/ArrayOfTransSeatSegRQ/TransSeatSegRQ') AS t1(col)	



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
CREATE PROCEDURE [dbo].[SP_PRO_TRANS_SEAT_TIME_UPDATE]
	@SEAT_CODE		INT,			-- 좌석코드
	@START			VARCHAR(10),	-- 복사시작일
	@END			VARCHAR(10),	-- 복사종료일
	@WEEK_DAY_TYPE	VARCHAR(7),		-- 요일
	@EMP_CODE		CHAR(7),		-- 생성인코드
	
	@DEP_SPEND_TIME VARCHAR(5),
	@ARR_SPEND_TIME VARCHAR(5),

	@SEGXML XML = NULL 
AS
BEGIN

--DECLARE @SEAT_CODE		INT,			-- 좌석코드
--	@START			VARCHAR(10),	-- 복사시작일
--	@END			VARCHAR(10),	-- 복사종료일
--	@WEEK_DAY_TYPE	VARCHAR(7),		-- 요일
--	@EMP_CODE		CHAR(7),		-- 생성인코드
	
--	@DEP_SPEND_TIME VARCHAR(5),
--	@ARR_SPEND_TIME VARCHAR(5)

--DECLARE @SEGXML XML 
--SET  @SEGXML = CONVERT(XML,'<ArrayOfTransSeatSegRQ xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <TransSeatSegRQ>
--    <SeatCode>7124255</SeatCode>
--    <TransSeq>1</TransSeq>
--    <SegNo>1</SegNo>
--    <DepartureAirportCode>ICN</DepartureAirportCode>
--    <ArrivalAirportCode>DAD</ArrivalAirportCode>
--    <AirlineCode>TW</AirlineCode>
--    <FlightNo>127 </FlightNo>
--    <DepartureDate>2019-05-01T21:10:00.000</DepartureDate>
--    <ArrivalDate>2019-05-01T23:50:00.000</ArrivalDate>
--    <NewDate xsi:nil="true" />
--    <RealAirlineCode />
--    <FlyingTime>02:40</FlyingTime>
--  </TransSeatSegRQ>
--  <TransSeatSegRQ>
--    <SeatCode>7124255</SeatCode>
--    <TransSeq>2</TransSeq>
--    <SegNo>1</SegNo>
--    <DepartureAirportCode>DAD</DepartureAirportCode>
--    <ArrivalAirportCode>ICN</ArrivalAirportCode>
--    <AirlineCode>TW</AirlineCode>
--    <FlightNo>126 </FlightNo>
--    <DepartureDate>2019-05-05T11:55:00.000</DepartureDate>
--    <ArrivalDate>2019-05-05T17:55:00.000</ArrivalDate>
--    <NewDate xsi:nil="true" />
--    <RealAirlineCode />
--    <FlyingTime>06:00</FlyingTime>
--  </TransSeatSegRQ>
--</ArrayOfTransSeatSegRQ>')



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

	DECLARE @START_DATE DATETIME, @END_DATE DATETIME, @DIFF_DAY INT, @DEP_DIFF INT, @ARR_DIFF INT
	DECLARE @DEP_DEP_TIME VARCHAR(5),@DEP_ARR_TIME VARCHAR(5),@ARR_DEP_TIME VARCHAR(5),@ARR_ARR_TIME VARCHAR(5)
	DECLARE @DEP_SPEND VARCHAR(5), @ARR_SPEND VARCHAR(5), @DEP_MINUTE INT, @ARR_MINUTE INT --, @NEW_SEAT_CODE INT



	SET @START_DATE = CONVERT(DATETIME, @START);	-- 업데이트 시작일
	SET @END_DATE = CONVERT(DATETIME, @END);		-- 업데이트 종료일
	--SET @FIRST = '1'								-- 최초 체크

	DECLARE @BASE_DEP_DATE DATETIME -- 기준 출국편 시작 날짜 
	DECLARE @BASE_ARR_DATE DATETIME -- 기준 귀국편 시작 날짜 
	
	SELECT
		@DIFF_DAY = DATEDIFF(DAY, DEP_DEP_DATE, ARR_DEP_DATE)   -- 출도착날짜 차이 
		, @DEP_DIFF = DATEDIFF(DAY, DEP_DEP_DATE, DEP_ARR_DATE)
		, @ARR_DIFF = DATEDIFF(DAY, DEP_DEP_DATE, ARR_ARR_DATE)
		--, @DEP_MINUTE = DATEDIFF(MI, (CONVERT(VARCHAR(10), DEP_DEP_DATE, 120) + ' ' + @DEP_DEP_TIME)
		--	, (CONVERT(VARCHAR(10), DEP_ARR_DATE, 120) + ' ' + @DEP_ARR_TIME))
		--, @ARR_MINUTE = DATEDIFF(MI, (CONVERT(VARCHAR(10), ARR_DEP_DATE, 120) + ' ' + @ARR_DEP_TIME)
		--	, (CONVERT(VARCHAR(10), ARR_ARR_DATE, 120) + ' ' + @ARR_ARR_TIME))

		,@BASE_DEP_DATE = DEP_DEP_DATE 
		,@BASE_ARR_DATE = ARR_DEP_DATE 
	FROM PRO_TRANS_SEAT WITH(NOLOCK)  WHERE SEAT_CODE = @SEAT_CODE

	-- 소요시간  2019-04-09 주석처리 
	--SELECT @DEP_SPEND = RIGHT('0' + CONVERT(VARCHAR(2), (@DEP_MINUTE / 60)), 2) + ':' + RIGHT('0' + CONVERT(VARCHAR(2), (@DEP_MINUTE % 60)), 2)
	--	, @ARR_SPEND = RIGHT('0' + CONVERT(VARCHAR(2), (@ARR_MINUTE / 60)), 2) + ':' + RIGHT('0' + CONVERT(VARCHAR(2), (@ARR_MINUTE % 60)), 2)

	-- 세그 정보로 좌석전체 넣음 
	--SELECT * FROM #TMP_SEG

	--2019-04-18 수정처리 
	--SELECT * FROM #TMP_SEG
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
		-- 좌석수정 
		UPDATE PRO_TRANS_SEAT SET
			DEP_DEP_TIME = @DEP_DEP_TIME, DEP_ARR_TIME = @DEP_ARR_TIME, DEP_SPEND_TIME = @DEP_SPEND
			, ARR_DEP_TIME = @ARR_DEP_TIME, ARR_ARR_TIME = @ARR_ARR_TIME, ARR_SPEND_TIME = @ARR_SPEND
			, EDT_DATE = GETDATE(), EDT_CODE = @EMP_CODE
		WHERE SEAT_CODE = @SEAT_CODE

	---- 임시 오류 
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
		SELECT (SELECT TOP 1 DEP_DEP_DATE FROM PRO_TRANS_SEAT WHERE SEAT_CODE = @SEAT_CODE ) , 1, '(기준좌석)성공'
						
						
		COMMIT TRAN 
						
		SET @BASE_SEAT_UPDATE_YN = 'Y'-- 수정완료  

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
		WHILE (@END_DATE >= @START_DATE)
		BEGIN
			BEGIN TRY
				IF '1' = SUBSTRING(@WEEK_DAY_TYPE, DATEPART(WEEKDAY, @START_DATE), 1)
				BEGIN
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
							AND B.DEP_DEP_DATE = @START_DATE AND B.DEP_ARR_DATE = DATEADD(DAY, @DEP_DIFF, @START_DATE)
							AND B.ARR_DEP_DATE = DATEADD(DAY, @DIFF_DAY, @START_DATE) AND B.ARR_ARR_DATE = DATEADD(DAY, @ARR_DIFF, @START_DATE)

					-- 해당일자에 좌석이 있는지 체크
					IF EXISTS ( SELECT * FROM @TARGET_SEAT_CODE ) 
					--IF ISNULL(@NEW_SEAT_CODE, 0) > 0
					BEGIN

						-- 각 세그 복사시 날짜 차이 계산 2019-04-18
						DECLARE @DIFF_DATE_DAY INT 
						SET @DIFF_DATE_DAY = DATEDIFF(DAY,@BASE_DEP_DATE,@START_DATE)
						
						--SELECT @DIFF_DEP_SEG_DAY , @DIFF_ARR_SEG_DAY 

						-- 기준좌석과 차이가 없고 중복좌석코드가 (일반석,비즈니스) 가 하나일때만 
						IF @DIFF_DATE_DAY = 0  AND (SELECT COUNT(*) FROM @TARGET_SEAT_CODE ) = 1 
						BEGIN
							INSERT INTO #MSG_TEMP 
							SELECT @START_DATE, 2, '기준좌석 이미수정됨'

							SET @START_DATE = DATEADD(DAY, 1, @START_DATE)

							
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

					------ 임시 오류 
					--DECLARE @A INT 
					--SET @A = 1/0
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
								DATEADD(DAY, @DIFF_DATE_DAY, A.ARR_DATE),  	-- 세그도착시각,  기준날짜와의 차이만큼 + 
								--DEP_DATE,ARR_DATE,
								@EMP_CODE,GETDATE(),REAL_AIRLINE_CODE,FLYING_TIME 
								FROM #TMP_SEG A 
								CROSS JOIN @TARGET_SEAT_CODE B


--	select '등록' ,  
--	a.SEAT_CODE , TRANS_SEQ,SEG_NO ,
--	DATEADD(DAY, @DIFF_DATE_DAY, DEP_DATE)	as new_dep_date , 	
--	DATEADD(DAY, @DIFF_DATE_DAY, ARR_DATE)  as new_dep_date  ,	
--	--DEP_DATE,ARR_DATE,
--	@EMP_CODE,GETDATE(),REAL_AIRLINE_CODE,FLYING_TIME 
--	FROM #TMP_SEG A 
--	CROSS JOIN @TARGET_SEAT_CODE B
--ORDER BY A.SEAT_CODE ASC  , 	TRANS_SEQ,SEG_NO 



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


--select '수정'  , a.seat_code,
--B.TRANS_SEQ  , b.seg_no,
--a.dep_date,
--DATEADD(DAY, @DIFF_DATE_DAY, B.DEP_DATE) as new_dep_date,	-- 출발시각, 출국편일때 출국차이+일
--a.arr_date  ,
--DATEADD(DAY, @DIFF_DATE_DAY, B.ARR_DATE) as new_arr_date , -- 도착시각, 출국편일때 출국차이+일
--@DIFF_DATE_DAY  as DEP_DATE_DAY 
--FROM PRO_TRANS_SEAT_SEGMENT A 
--	INNER JOIN #TMP_SEG B 
--		ON A.TRANS_SEQ = B.TRANS_SEQ 
--		AND A.SEG_NO = B.SEG_NO 
--WHERE A.SEAT_CODE IN ( SELECT SEAT_CODE FROM @TARGET_SEAT_CODE )  
--ORDER BY A.SEAT_CODE ASC ,B.TRANS_SEQ  , b.seg_no

							END 
					
							INSERT INTO #MSG_TEMP 
							SELECT @START_DATE, 1, '성공'
					 
							COMMIT TRAN 

						END TRY
						BEGIN CATCH
							ROLLBACK TRAN 

							INSERT INTO #MSG_TEMP 
							SELECT @START_DATE, 2, '시간수정오류:'+ ERROR_MESSAGE()

						END CATCH 
						---------------------------------------------------

					END
					ELSE
					BEGIN
						INSERT INTO #MSG_TEMP 
						SELECT @START_DATE, 2, '좌석정보없음'
					END
					
				END

				--PRINT @START_DATE
			END TRY
			BEGIN CATCH
				-- LOG INSERT
				INSERT INTO #MSG_TEMP 
				SELECT @START_DATE, 2, ERROR_MESSAGE()
			END CATCH

			SET @START_DATE = DATEADD(DAY, 1, @START_DATE)
		END
		----- 루프 끝-----
	END 

	-- 처리결과 SELECT 
	SELECT * FROM #MSG_TEMP
	
	DROP TABLE #MSG_TEMP

END

GO
