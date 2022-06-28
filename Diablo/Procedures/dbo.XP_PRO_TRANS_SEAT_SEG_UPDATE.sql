USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: XP_PRO_TRANS_SEAT_SEG_UPDATE  
■ Description				: 마스터의 좌석 정보 일괄정보 업데이트
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_PRO_TRANS_SEAT_SEG_UPDATE '
■ Author					: 박형만  
■ Date						: 2019-07-16
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2019-07-16		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE  PROC [dbo].[XP_PRO_TRANS_SEAT_SEG_UPDATE] 
	@SEAT_CODE INT,
	
	@FARE_SEAT_TYPE INT,

	@DEP_SPEND_TIME VARCHAR(5), -- 총시간은 계산해서 
	@ARR_SPEND_TIME VARCHAR(5), -- 총시간은 계산해서 

	@EDT_CODE VARCHAR(7) ,

	@SEGXML XML 
AS 
BEGIN

--DECLARE @DEP_SPEND_TIME VARCHAR(5),
--@ARR_SPEND_TIME VARCHAR(5) 

--DECLARE @SEGXML XML 
--SET  @SEGXML = CONVERT(XML,'<ArrayOfTransSeatSegRQ xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <TransSeatSegRQ>
--    <SeatCode>8222358</SeatCode>
--    <TransSeq>1</TransSeq>
--    <SegNo>1</SegNo>
--    <DepartureAirportCode>ICN</DepartureAirportCode>
--    <ArrivalAirportCode>CJJ</ArrivalAirportCode>
--    <AirlineCode>ZE</AirlineCode>
--    <FlightNo>781</FlightNo>
--    <DepartureDate>2019-07-21T16:10:00.000</DepartureDate>
--    <ArrivalDate>2019-07-21T18:53:00.000</ArrivalDate>
--    <NewDate xsi:nil="true" />
--    <RealAirlineCode />
--    <FlyingTime>02:40</FlyingTime>
--  </TransSeatSegRQ>
--   <TransSeatSegRQ>
--    <SeatCode>8222358</SeatCode>
--    <TransSeq>1</TransSeq>
--    <SegNo>2</SegNo>
--    <DepartureAirportCode>CJJ</DepartureAirportCode>
--    <ArrivalAirportCode>TPE</ArrivalAirportCode>
--    <AirlineCode>ZE</AirlineCode>
--    <FlightNo>7812</FlightNo>
--    <DepartureDate>2019-07-21T20:10:00.000</DepartureDate>
--    <ArrivalDate>2019-07-21T22:53:00.000</ArrivalDate>
--    <NewDate xsi:nil="true" />
--    <RealAirlineCode />
--    <FlyingTime>02:40</FlyingTime>
--  </TransSeatSegRQ>

--  <TransSeatSegRQ>
--    <SeatCode>8222358</SeatCode>
--    <TransSeq>2</TransSeq>
--    <SegNo>1</SegNo>
--    <DepartureAirportCode>TPE</DepartureAirportCode>
--    <ArrivalAirportCode>CJJ</ArrivalAirportCode>
--    <AirlineCode>ZE</AirlineCode>
--    <FlightNo>782</FlightNo>
--    <DepartureDate>2019-07-23T17:00:00.000</DepartureDate>
--    <ArrivalDate>2019-07-23T20:15:00.000</ArrivalDate>
--    <NewDate xsi:nil="true" />
--    <RealAirlineCode />
--    <FlyingTime>03:00</FlyingTime>
--  </TransSeatSegRQ>
--  <TransSeatSegRQ>
--    <SeatCode>8222358</SeatCode>
--    <TransSeq>2</TransSeq>
--    <SegNo>2</SegNo>
--    <DepartureAirportCode>CJJ</DepartureAirportCode>
--    <ArrivalAirportCode>ICN</ArrivalAirportCode>
--    <AirlineCode>ZE</AirlineCode>
--    <FlightNo>7822</FlightNo>
--    <DepartureDate>2019-07-23T21:00:00.000</DepartureDate>
--    <ArrivalDate>2019-07-23T22:15:00.000</ArrivalDate>
--    <NewDate xsi:nil="true" />
--    <RealAirlineCode />
--    <FlyingTime>01:00</FlyingTime>
--  </TransSeatSegRQ>
--</ArrayOfTransSeatSegRQ>')

	-- 세그정보 XML 
	--DROP TABLE #TMP_SEG
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

--SELECT * FROM #TMP_SEG 

	DECLARE 
	@DEP_TRANS_NUMBER VARCHAR(4) ,
	@ARR_TRANS_NUMBER VARCHAR(4) ,

	@DEP_DEP_DATE DATETIME,
	@DEP_ARR_DATE DATETIME,

	@DEP_DEP_TIME VARCHAR(5),
	@DEP_ARR_TIME VARCHAR(5),

	@ARR_DEP_DATE DATETIME,
	@ARR_ARR_DATE DATETIME,

	@ARR_DEP_TIME VARCHAR(5),
	@ARR_ARR_TIME VARCHAR(5),

	@DEP_DEP_AIRPORT_CODE VARCHAR(3),
	@DEP_ARR_AIRPORT_CODE VARCHAR(3),
	@ARR_DEP_AIRPORT_CODE VARCHAR(3),
	@ARR_ARR_AIRPORT_CODE VARCHAR(3)

 
	--출발편 채우기 
	SELECT TOP 1 
	@DEP_TRANS_NUMBER = FLIGHT ,@DEP_DEP_AIRPORT_CODE = DEP_AIRPORT_CODE,  
	@DEP_DEP_DATE = CONVERT(VARCHAR(10),DEP_DATE,121) , @DEP_DEP_TIME = RIGHT(CONVERT(VARCHAR(16),DEP_DATE,121),5) 
	FROM #TMP_SEG WHERE TRANS_SEQ = 1 ORDER BY SEG_NO ASC  -- 여정1 

	SELECT TOP 1 
	@DEP_ARR_AIRPORT_CODE = ARR_AIRPORT_CODE,  
	@DEP_ARR_DATE = CONVERT(VARCHAR(10),ARR_DATE,121) , @DEP_ARR_TIME = RIGHT(CONVERT(VARCHAR(16),ARR_DATE,121),5) 
	FROM #TMP_SEG WHERE TRANS_SEQ = 1 ORDER BY SEG_NO DESC  -- 여정1 
--SELECT @DEP_TRANS_NUMBER ,@DEP_DEP_AIRPORT_CODE , @DEP_ARR_AIRPORT_CODE , @DEP_DEP_DATE , @DEP_DEP_TIME , @DEP_ARR_DATE ,@DEP_ARR_TIME 

	--도착편 채우기 
	SELECT TOP 1 
	@ARR_TRANS_NUMBER = FLIGHT ,@ARR_DEP_AIRPORT_CODE = DEP_AIRPORT_CODE,  
	@ARR_DEP_DATE = CONVERT(VARCHAR(10),DEP_DATE,121) , @ARR_DEP_TIME = RIGHT(CONVERT(VARCHAR(16),DEP_DATE,121),5) 
	FROM #TMP_SEG WHERE TRANS_SEQ = 2 ORDER BY SEG_NO ASC  -- 여정1 

	SELECT TOP 1 
	@ARR_ARR_AIRPORT_CODE = ARR_AIRPORT_CODE,  
	@ARR_ARR_DATE = CONVERT(VARCHAR(10),ARR_DATE,121) , @ARR_ARR_TIME = RIGHT(CONVERT(VARCHAR(16),ARR_DATE,121),5) 
	FROM #TMP_SEG WHERE TRANS_SEQ = 2 ORDER BY SEG_NO DESC  -- 여정1 
--SELECT @ARR_TRANS_NUMBER ,@ARR_DEP_AIRPORT_CODE , @ARR_ARR_AIRPORT_CODE , @ARR_DEP_DATE , @ARR_DEP_TIME , @ARR_ARR_DATE ,@ARR_ARR_TIME 

---- 수정할 SEAT_CODE 
--SET @SEAT_CODES = '8222358,8222359,8222360,8222361,8222362,8222363,8222364,8222365,8222366,8222367,8222368'
	
	IF ( SELECT COUNT(*) FROM #TMP_SEG  ) > 0 
	BEGIN
		BEGIN TRAN  
	
		-- 값 처리 
		UPDATE A 
		SET A.DEP_TRANS_NUMBER = @DEP_TRANS_NUMBER 
			,A.ARR_TRANS_NUMBER = @ARR_TRANS_NUMBER
			,A.DEP_DEP_AIRPORT_CODE = @DEP_DEP_AIRPORT_CODE
			,A.DEP_ARR_AIRPORT_CODE = @DEP_ARR_AIRPORT_CODE
			,A.ARR_DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE
			,A.ARR_ARR_AIRPORT_CODE = @ARR_ARR_AIRPORT_CODE

			,A.DEP_DEP_TIME = @DEP_DEP_TIME
			,A.DEP_ARR_TIME = @DEP_ARR_TIME
			,A.ARR_DEP_TIME = @ARR_DEP_TIME
			,A.ARR_ARR_TIME = @ARR_ARR_TIME

			,A.DEP_SPEND_TIME = @DEP_SPEND_TIME
			,A.ARR_SPEND_TIME = @ARR_SPEND_TIME

			,A.DEP_DEP_DATE = @DEP_DEP_DATE 
			,A.DEP_ARR_DATE = @DEP_ARR_DATE 
			,A.ARR_DEP_DATE = @ARR_DEP_DATE 
			,A.ARR_ARR_DATE = @ARR_ARR_DATE 

			,A.FARE_SEAT_TYPE = @FARE_SEAT_TYPE
			,A.EDT_CODE = @EDT_CODE  
			,A.EDT_DATE = GETDATE() 
		--확인시 
		--SELECT A.* ,@@EDT_CODE , GETDATE() 
		FROM PRO_TRANS_SEAT A 
		WHERE SEAT_CODE = @SEAT_CODE 

		----------------------------------------------------------
		-- 한건 일때 & 상세그 있을때  상세 세그도처리 
		IF @SEGXML IS NOT NULL 
		BEGIN

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
				DEP_DATE,ARR_DATE,@EDT_CODE,GETDATE(),REAL_AIRLINE_CODE,FLYING_TIME 
				FROM #TMP_SEG A 
			END 
			ELSE
			BEGIN
				-- 시간관련 업데이트 
				UPDATE A 
				SET A.DEP_DATE = B.DEP_DATE 
					,A.ARR_DATE = B.ARR_DATE 
					,A.FLYING_TIME = B.FLYING_TIME
					,A.DEP_AIRPORT_CODE = B.DEP_AIRPORT_CODE 
					,A.ARR_AIRPORT_CODE = B.ARR_AIRPORT_CODE 
					,A.FLIGHT = B.FLIGHT 
					,A.REAL_AIRLINE_CODE = B.REAL_AIRLINE_CODE 
					,A.EDT_CODE = @EDT_CODE 
					,A.EDT_DATE = GETDATE() 
				FROM PRO_TRANS_SEAT_SEGMENT A 
					INNER JOIN #TMP_SEG B 
						ON A.TRANS_SEQ = B.TRANS_SEQ 
						AND A.SEG_NO = B.SEG_NO 
				WHERE A.SEAT_CODE = @SEAT_CODE						
			END

		END 

		SELECT 1 

		----------------------------------------------------------
		COMMIT TRAN 

	END 
	ELSE 
	BEGIN
		SELECT -1 
	END 

END 

GO
