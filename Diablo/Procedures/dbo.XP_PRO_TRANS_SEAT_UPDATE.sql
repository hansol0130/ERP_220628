USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: XP_PRO_TRANS_SEAT_UPDATE  
■ Description				: 좌석 정보 수정
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC XP_PRO_TRANS_SEAT_UPDATE  
■ Author					: 박형만  
■ Date						: 2019-04-01
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2019-04-01		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[XP_PRO_TRANS_SEAT_UPDATE]
(	
	@SEAT_CODE INT , 

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
	@ARR_TRANS_NUMBER varchar(4),		
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
	@EDT_CODE CHAR(7) ,				
	@MAX_SEAT_COUNT int,		
	@FARE_SEAT_TYPE int,

	@UPD_TYPE INT  = 0 ,  --0 전체 수정 ,  1 스케쥴만 수정시 

	@PRO_CODE VARCHAR(30) = NULL ,
	@SEGXML XML = NULL 
)
AS
BEGIN

	-- 스케쥴만 수정 , 좌석 금액 , 좌석수 등은 수정안함 
	IF @UPD_TYPE = 1 
	BEGIN
		UPDATE PRO_TRANS_SEAT SET
			DEP_DEP_DATE = @DEP_DEP_DATE, DEP_ARR_DATE = @DEP_ARR_DATE,  DEP_DEP_TIME = @DEP_DEP_TIME,
			DEP_ARR_TIME = @DEP_ARR_TIME, DEP_SPEND_TIME = @DEP_SPEND_TIME, DEP_DEP_AIRPORT_CODE = @DEP_DEP_AIRPORT_CODE,
			DEP_ARR_AIRPORT_CODE = @DEP_ARR_AIRPORT_CODE,      ARR_DEP_DATE = @ARR_DEP_DATE,
			ARR_ARR_DATE = @ARR_ARR_DATE, ARR_DEP_TIME = @ARR_DEP_TIME,  ARR_ARR_TIME = @ARR_ARR_TIME,
			ARR_SPEND_TIME = @ARR_SPEND_TIME,
			ARR_DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE,
			ARR_ARR_AIRPORT_CODE = @ARR_ARR_AIRPORT_CODE,
			FARE_SEAT_TYPE = @FARE_SEAT_TYPE, -- 좌석등급 
			EDT_DATE = GETDATE(),    EDT_CODE = @EDT_CODE
		WHERE SEAT_CODE = @SEAT_CODE
	END 
	ELSE 
	BEGIN
		UPDATE PRO_TRANS_SEAT SET
			DEP_DEP_DATE = @DEP_DEP_DATE,	DEP_ARR_DATE = @DEP_ARR_DATE,		DEP_DEP_TIME = @DEP_DEP_TIME,
			DEP_ARR_TIME = @DEP_ARR_TIME,	DEP_SPEND_TIME = @DEP_SPEND_TIME,	DEP_DEP_AIRPORT_CODE = @DEP_DEP_AIRPORT_CODE,
			DEP_ARR_AIRPORT_CODE	= @DEP_ARR_AIRPORT_CODE,						ARR_DEP_DATE = @ARR_DEP_DATE,
			ARR_ARR_DATE	= @ARR_ARR_DATE,	ARR_DEP_TIME = @ARR_DEP_TIME,		ARR_ARR_TIME = @ARR_ARR_TIME,
			ARR_SPEND_TIME = @ARR_SPEND_TIME,
			ARR_DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE,
			ARR_ARR_AIRPORT_CODE = @ARR_ARR_AIRPORT_CODE,
			FARE_SEAT_TYPE = @FARE_SEAT_TYPE, -- 좌석등급 

			ADT_PRICE = @ADT_PRICE,			CHD_PRICE = @CHD_PRICE,				INF_PRICE = @INF_PRICE,
			SEAT_COUNT = @SEAT_COUNT,		MAX_SEAT_COUNT = @MAX_SEAT_COUNT,	SEAT_TYPE = @SEAT_TYPE,
			TRANS_TYPE = @TRANS_TYPE,		EDT_DATE = GETDATE(),				EDT_CODE = @EDT_CODE
		WHERE SEAT_CODE = @SEAT_CODE
	END 
	
	IF @SEGXML IS NOT NULL 
	BEGIN
		-- 상세세그 삭제 
		DELETE PRO_TRANS_SEAT_SEGMENT 
		WHERE SEAT_CODE = @SEAT_CODE 

		-- 상세세그도 재 입력해준다 
		INSERT PRO_TRANS_SEAT_SEGMENT 
		(SEAT_CODE,TRANS_SEQ,SEG_NO,DEP_AIRPORT_CODE,ARR_AIRPORT_CODE,AIRLINE_CODE,FLIGHT,
		DEP_DATE,ARR_DATE,NEW_CODE,NEW_DATE,REAL_AIRLINE_CODE,FLYING_TIME)
		--VALUES 
		--(@SEAT_CODE,@TRANS_SEQ,@SEG_NO,@DEP_AIRPORT_CODE,@ARR_AIRPORT_CODE,@AIRLINE_CODE,@FLIGHT,
		--@DEP_DATE,@ARR_DATE,@NEW_CODE,GETDATE(),@REAL_AIRLINE_CODE,@FLYING_TIME )
		SELECT 
		@SEAT_CODE,
		t1.col.value ( './TransSeq[1]' ,'int'),
		t1.col.value ( './SegNo[1]' ,'int'),
		t1.col.value ( './DepartureAirportCode[1]' ,'varchar(3)'),
		t1.col.value ( './ArrivalAirportCode[1]' ,'varchar(3)'),
		t1.col.value ( './AirlineCode[1]' ,'varchar(2)'),
		t1.col.value ( './FlightNo[1]' ,'varchar(5)'),
		t1.col.value ( './DepartureDate[1]' ,'datetime'),
		t1.col.value ( './ArrivalDate[1]' ,'datetime'),
		@EDT_CODE,
		GETDATE(),
		t1.col.value ( './RealAirlineCode[1]' ,'varchar(2)'),
		t1.col.value ( './FlyingTime[1]' ,'varchar(5)')
		FROM @SEGXML.nodes('/ArrayOfTransSeatSegRQ/TransSeatSegRQ') AS t1(col)	

	END 
END 



GO
