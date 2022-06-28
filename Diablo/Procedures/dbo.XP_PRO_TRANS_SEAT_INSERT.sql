USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ USP_Name					: XP_PRO_TRANS_SEAT_INSERT  
■ Description				: 좌석 정보 신규 등록 
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_PRO_TRANS_SEAT_INSERT  
■ Author					: 박형만  
■ Date						: 2019-04-01
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2019-04-01		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[XP_PRO_TRANS_SEAT_INSERT]
(	
	@DEP_TRANS_CODE char(2),		
	@DEP_TRANS_NUMBER char(4),		
	@DEP_DEP_DATE datetime,			
	@DEP_ARR_DATE datetime,
	@DEP_DEP_TIME char(5),			
	@DEP_ARR_TIME char(5),			
	@DEP_SPEND_TIME char(5),		
	@DEP_DEP_AIRPORT_CODE	char(3),		
	@DEP_ARR_AIRPORT_CODE	char(3),		
	@ARR_DEP_AIRPORT_CODE	char(3),		
	@ARR_ARR_AIRPORT_CODE	char(3),		
	@ARR_TRANS_CODE char(2),	
	@ARR_TRANS_NUMBER char(4),		
	@ARR_DEP_DATE datetime,			
	@ARR_ARR_DATE datetime,		
	@ARR_DEP_TIME char(5),	
	@ARR_ARR_TIME char(5),		
	@ARR_SPEND_TIME char(5),		
	@ADT_PRICE int,				
	@CHD_PRICE int,
	@INF_PRICE int,				
	@SEAT_COUNT int,			
	@SEAT_TYPE int,			
	@TRANS_TYPE int,			
	@NEW_CODE NEW_CODE ,				
	@MAX_SEAT_COUNT int,		
	@FARE_SEAT_TYPE int,

	@PRO_CODE VARCHAR(30) = NULL ,
	@SEGXML XML = NULL 
)
AS 
-- 동일한 항공편은 중복 생성 할 수 없음
BEGIN
	DECLARE @NEW_SEAT_CODE INT
	DECLARE @ORG_SEAT_CODE VARCHAR(20)
	
	SELECT TOP 1 @ORG_SEAT_CODE = CONVERT(VARCHAR(20), SEAT_CODE) FROM PRO_TRANS_SEAT
	WHERE DEP_TRANS_CODE = @DEP_TRANS_CODE AND DEP_TRANS_NUMBER = @DEP_TRANS_NUMBER
		AND ARR_TRANS_CODE = @ARR_TRANS_CODE AND ARR_TRANS_NUMBER = @ARR_TRANS_NUMBER
		AND DEP_DEP_AIRPORT_CODE = @DEP_DEP_AIRPORT_CODE AND DEP_ARR_AIRPORT_CODE = @DEP_ARR_AIRPORT_CODE
		AND ARR_DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE AND ARR_ARR_AIRPORT_CODE = @ARR_ARR_AIRPORT_CODE
		AND DEP_DEP_DATE = @DEP_DEP_DATE AND DEP_ARR_DATE = @DEP_ARR_DATE
		AND ARR_DEP_DATE = @ARR_DEP_DATE AND ARR_ARR_DATE = @ARR_ARR_DATE
		AND FARE_SEAT_TYPE = @FARE_SEAT_TYPE   -- 좌석등급도 추가 
	ORDER BY SEAT_CODE
	
	IF @ORG_SEAT_CODE IS NULL
	BEGIN

		BEGIN TRAN
		BEGIN TRY

			INSERT INTO PRO_TRANS_SEAT (
				DEP_TRANS_CODE,			DEP_TRANS_NUMBER,		DEP_DEP_DATE,			DEP_ARR_DATE,
				DEP_DEP_TIME,			DEP_ARR_TIME,			DEP_SPEND_TIME,			DEP_DEP_AIRPORT_CODE,
				DEP_ARR_AIRPORT_CODE,	ARR_DEP_AIRPORT_CODE,	ARR_ARR_AIRPORT_CODE,	ARR_TRANS_CODE,
				ARR_TRANS_NUMBER,		ARR_DEP_DATE,			ARR_ARR_DATE,			ARR_DEP_TIME,
				ARR_ARR_TIME,			ARR_SPEND_TIME,			ADT_PRICE,				CHD_PRICE,
				INF_PRICE,				SEAT_COUNT,				SEAT_TYPE,				TRANS_TYPE,
				NEW_DATE,				NEW_CODE,				MAX_SEAT_COUNT,			FARE_SEAT_TYPE 
			) VALUES (
				@DEP_TRANS_CODE,		@DEP_TRANS_NUMBER,		@DEP_DEP_DATE,			@DEP_ARR_DATE,
				@DEP_DEP_TIME,			@DEP_ARR_TIME,			@DEP_SPEND_TIME,		@DEP_DEP_AIRPORT_CODE,
				@DEP_ARR_AIRPORT_CODE,	@ARR_DEP_AIRPORT_CODE,	@ARR_ARR_AIRPORT_CODE,	@ARR_TRANS_CODE,
				@ARR_TRANS_NUMBER,		@ARR_DEP_DATE,			@ARR_ARR_DATE,			@ARR_DEP_TIME,
				@ARR_ARR_TIME,			@ARR_SPEND_TIME,		@ADT_PRICE,				@CHD_PRICE,
				@INF_PRICE,				@SEAT_COUNT,			@SEAT_TYPE,				@TRANS_TYPE,
				GETDATE(),				@NEW_CODE,				@MAX_SEAT_COUNT,		@FARE_SEAT_TYPE
			)

			SET @NEW_SEAT_CODE = @@IDENTITY
			
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
	

	---- 임시 오류 
	--DECLARE @A INT 
	--SET  @A = 1 / 0 

			-- 상세세그도 입력해준다 
			INSERT PRO_TRANS_SEAT_SEGMENT 
			(SEAT_CODE,TRANS_SEQ,SEG_NO,DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,FLIGHT,
			DEP_DATE,ARR_DATE,NEW_CODE,NEW_DATE,REAL_AIRLINE_CODE,FLYING_TIME)
			--VALUES 
			--(@SEAT_CODE,@TRANS_SEQ,@SEG_NO,@DEP_AIRPORT_CODE,@ARR_AIRPORT_CODE,@AIRLINE_CODE,@FLIGHT,
			--@DEP_DATE,@ARR_DATE,@NEW_CODE,GETDATE(),@REAL_AIRLINE_CODE,@FLYING_TIME )
			SELECT 
			@NEW_SEAT_CODE,TRANS_SEQ,SEG_NO,DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,FLIGHT,
			DEP_DATE,ARR_DATE,@NEW_CODE,GETDATE(),REAL_AIRLINE_CODE,FLYING_TIME
			FROM #TMP_SEG

			-- 출발 교통편이 있는 경우 갱신해주기
			IF EXISTS (SELECT * FROM PRO_TRANS_MASTER WHERE TRANS_CODE = @DEP_TRANS_CODE 
				AND TRANS_NUMBER = @DEP_TRANS_NUMBER 
				AND DEP_AIRPORT_CODE = @DEP_DEP_AIRPORT_CODE 
				AND ARR_AIRPORT_CODE = @DEP_ARR_AIRPORT_CODE  )
			BEGIN
				UPDATE PRO_TRANS_MASTER 
				SET DEP_TIME = @DEP_DEP_TIME 
					,ARR_TIME = @DEP_ARR_TIME 
					,EDT_CODE = @NEW_CODE 
					,EDT_DATE = GETDATE()
					--,WEEKDAY_TYPE = 
				WHERE TRANS_CODE = @DEP_TRANS_CODE 
				AND TRANS_NUMBER = @DEP_TRANS_NUMBER 
				AND DEP_AIRPORT_CODE = @DEP_DEP_AIRPORT_CODE 
				AND ARR_AIRPORT_CODE = @DEP_ARR_AIRPORT_CODE  
				--SELECT TOP 100 * FROM PRO_TRANS_MASTER
				--ORDER BY NEW_DATE DESC 
			END 
			ELSE  -- 출발교통편 없을경우 생성해주기 
			BEGIN
				INSERT INTO PRO_TRANS_MASTER
				(TRANS_CODE,TRANS_NUMBER,
				DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,
				TRANS_TYPE,DEP_TIME,ARR_TIME,
				WEEKDAY_TYPE,NEW_DATE,NEW_CODE,
				TRANS_REAL_CODE)
				SELECT @DEP_TRANS_CODE,@DEP_TRANS_NUMBER,
				@DEP_DEP_AIRPORT_CODE,@DEP_ARR_AIRPORT_CODE,
				@TRANS_TYPE, @DEP_DEP_TIME , @DEP_ARR_TIME,
				'1111111' ,GETDATE(),@NEW_CODE,
				(SELECT TOP 1 REAL_AIRLINE_CODE FROM #TMP_SEG WHERE TRANS_SEQ =1 AND REAL_AIRLINE_CODE IS NOT NULL AND REAL_AIRLINE_CODE <> '' 
				ORDER BY SEG_NO )
			END 

			-- 귀국 교통편이 있는 경우 갱신해주기
			IF EXISTS (SELECT * FROM PRO_TRANS_MASTER WHERE TRANS_CODE = @ARR_TRANS_CODE 
				AND TRANS_NUMBER = @ARR_TRANS_NUMBER 
				AND DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE 
				AND ARR_AIRPORT_CODE = @ARR_ARR_AIRPORT_CODE  )
			BEGIN
				UPDATE PRO_TRANS_MASTER 
				SET DEP_TIME = @ARR_DEP_TIME  
					,ARR_TIME = @ARR_ARR_TIME 
					,EDT_CODE = @NEW_CODE 
					,EDT_DATE = GETDATE()
				WHERE TRANS_CODE = @ARR_TRANS_CODE 
				AND TRANS_NUMBER = @ARR_TRANS_NUMBER 
				AND DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE 
				AND ARR_AIRPORT_CODE = @ARR_ARR_AIRPORT_CODE  
			END
			ELSE -- 귀국교통편 없을경우 생성해주기
			BEGIN
				INSERT INTO PRO_TRANS_MASTER
				(TRANS_CODE,TRANS_NUMBER,
				DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,
				TRANS_TYPE,DEP_TIME,ARR_TIME,
				WEEKDAY_TYPE,NEW_DATE,NEW_CODE,
				TRANS_REAL_CODE)
				SELECT @ARR_TRANS_CODE,@ARR_TRANS_NUMBER,
				@ARR_DEP_AIRPORT_CODE,@ARR_ARR_AIRPORT_CODE,
				@TRANS_TYPE, @ARR_DEP_TIME , @ARR_ARR_TIME ,
				'1111111' ,GETDATE(),@NEW_CODE,
				(SELECT TOP 1 REAL_AIRLINE_CODE FROM #TMP_SEG WHERE TRANS_SEQ =2 AND REAL_AIRLINE_CODE IS NOT NULL AND REAL_AIRLINE_CODE <> '' 
				ORDER BY SEG_NO )
			END 


			--행사코드가 있을경우 신규 행사에 신규 좌석 매칭해주기 
			IF ISNULL(@PRO_CODE,'') <> ''
			BEGIN
				UPDATE PKG_DETAIL 
				SET SEAT_CODE = @NEW_SEAT_CODE 
				WHERE PRO_CODE = @PRO_CODE 
			END 

			-- TRANS COMMIT 
			IF @@TRANCOUNT > 0	
			BEGIN
				COMMIT TRAN    

			END 

			-- 정상등록된 코드 반환 T|좌석코드 
			SELECT 'T|' + CONVERT(VARCHAR, @NEW_SEAT_CODE)

		END TRY    
		BEGIN CATCH    
			-- TRANS ROLLBACK 
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN    
    
			RAISERROR('좌석등록시 오류가 발생 하였습니다', 16, 1 ) 
			
			SELECT 'E|' + CONVERT(VARCHAR, ISNULL(@NEW_SEAT_CODE,-1))  -- 에러 
			 
		END CATCH

	END
	ELSE
	BEGIN
		--기존 동일 좌석 존재 기존코드 반환 F|좌석코드 
		SELECT 'F|' + @ORG_SEAT_CODE
	END

END




GO
