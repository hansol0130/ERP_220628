USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
■ USP_Name					: SP_PRO_TRANS_SEAT_INSERT  
■ Description				: 좌석 정보 신규 등록 
■ Input Parameter			:                  


■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						: EXEC SP_PRO_TRANS_SEAT_INSERT  
■ Author					: 박형만  
■ Date						: 2019-04-01
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2019-04-01		박형만			최초생성  
-------------------------------------------------------------------------------------------------*/ 
CREATE PROC [dbo].[SP_PRO_TRANS_SEAT_INSERT]
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
	@FARE_SEAT_TYPE int
)
AS 
-- 동일한 항공편은 중복 생성 할 수 없음
BEGIN
	DECLARE @VALUE VARCHAR(20)
	
	SELECT TOP 1 @VALUE = CONVERT(VARCHAR(20), SEAT_CODE) FROM PRO_TRANS_SEAT
	WHERE DEP_TRANS_CODE = @DEP_TRANS_CODE AND DEP_TRANS_NUMBER = @DEP_TRANS_NUMBER
		AND ARR_TRANS_CODE = @ARR_TRANS_CODE AND ARR_TRANS_NUMBER = @ARR_TRANS_NUMBER
		AND DEP_DEP_AIRPORT_CODE = @DEP_DEP_AIRPORT_CODE AND DEP_ARR_AIRPORT_CODE = @DEP_ARR_AIRPORT_CODE
		AND ARR_DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE AND ARR_ARR_AIRPORT_CODE = @ARR_ARR_AIRPORT_CODE
		AND DEP_DEP_DATE = @DEP_DEP_DATE AND DEP_ARR_DATE = @DEP_ARR_DATE
		AND ARR_DEP_DATE = @ARR_DEP_DATE AND ARR_ARR_DATE = @ARR_ARR_DATE
		AND FARE_SEAT_TYPE = @FARE_SEAT_TYPE   -- 좌석등급도 추가 
	ORDER BY SEAT_CODE
	
	IF @VALUE IS NULL
	BEGIN
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
		SELECT @VALUE = 'T|' + CONVERT(VARCHAR(10), @@IDENTITY)

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


	END
	ELSE
	BEGIN
		SELECT @VALUE = 'F|' + @VALUE
	END
	
	SELECT @VALUE
END


GO
