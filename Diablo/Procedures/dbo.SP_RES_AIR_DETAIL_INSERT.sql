USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<문태중>
-- Create date: <2009-02-24>
-- Description:	<항공 관련 예약 정보를 추가한다>
-- =============================================
CREATE PROCEDURE [dbo].[SP_RES_AIR_DETAIL_INSERT]
	@RES_CODE	CHAR(12),
	@PRO_CODE	VARCHAR(20),
	@NEW_CODE	CHAR(7)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM FARE_GROUP WHERE PRO_CODE = @PRO_CODE)   --오프라인 예약일 경우에
	BEGIN
		--항공 예약 상세 정보 저장
		INSERT INTO RES_AIR_DETAIL
		(
			RES_CODE,		PRO_CODE,		AIR_PRO_TYPE,			AIR_GDS,
			PNR_CODE1,		AIRLINE_CODE,	TTL_DATE,				ADT_PRICE,
			CHD_PRICE,		INF_PRICE,		ADT_TAX,				CHD_TAX,
			INF_TAX,		BKG_CLASS,		DEP_DEP_DATE,			DEP_ARR_DATE,
			DEP_DEP_TIME,	DEP_ARR_TIME,	DEP_DEP_AIRPORT_CODE,	DEP_ARR_AIRPORT_CODE,
			ARR_DEP_DATE,	ARR_ARR_DATE,	ARR_DEP_AIRPORT_CODE,	ARR_ARR_AIRPORT_CODE,
			ARR_DEP_TIME,	ARR_ARR_TIME
		)
		SELECT
			@RES_CODE,		PRO_CODE,		PRO_TYPE,				CRS,
			PNR_CODE,		AIRLINE_CODE,	TL_DATE,				ADT_PRICE,
			CHD_PRICE,		INF_PRICE,		ADT_TAX_PRICE,			CHD_TAX_PRICE,
			INF_TAX_PRICE,	BKG_CLASS,		DEP_DEP_DATE,			DEP_ARR_DATE,
			DEP_DEP_TIME,	DEP_ARR_TIME,	DEP_DEP_AIRPORT_CODE,	DEP_ARR_AIRPORT_CODE,
			ARR_DEP_DATE,	ARR_ARR_DATE,	ARR_DEP_AIRPORT_CODE,	ARR_ARR_AIRPORT_CODE,
			ARR_DEP_TIME,	ARR_ARR_TIME	
		FROM FARE_GROUP
		WHERE PRO_CODE = @PRO_CODE;

		--항공 예약 마스터 출도착일 업데이트	
		UPDATE RES_MASTER_damo SET
			DEP_DATE = B.DEP_DEP_DATE,		ARR_DATE = B.ARR_ARR_DATE,
			LAST_PAY_DATE = DATEADD(DAY, -7, B.DEP_DEP_DATE)
		FROM FARE_GROUP B 
		WHERE B.PRO_CODE = @PRO_CODE AND RES_CODE = @RES_CODE

		--세그 정보 저장
		--상세 세그 정보가 있을 경우와 없을 경우를 비교해야 하기 때문에 부득이 하게 IF문을 사용

		IF EXISTS(SELECT 1 FROM FARE_GROUP_SEGMENT WHERE PRO_CODE = @PRO_CODE)
		BEGIN
			INSERT INTO RES_SEGMENT
			(
				RES_CODE,				SEQ_NO,					DEP_AIRPORT_CODE,		ARR_AIRPORT_CODE,
				DEP_CITY_CODE,			
				ARR_CITY_CODE,			
				AIRLINE_CODE,			START_DATE,
				END_DATE,				FLIGHT,					NEW_CODE,				NEW_DATE,
				SEAT_STATUS			
			)
			SELECT
				@RES_CODE,				A.SEG_NO,				A.DEP_AIRPORT_CODE,		A.ARR_AIRPORT_CODE,				
				(SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = A.DEP_AIRPORT_CODE) AS DEP_CITY_CODE,		
				(SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = A.ARR_AIRPORT_CODE) AS ARR_CITY_CODE,
				A.AIRLINE_CODE,			A.DEP_DATE,				
				A.ARR_DATE,				A.FLIGHT,				@NEW_CODE,				GETDATE(),
				A.SEAT_STATUS
			FROM FARE_GROUP_SEGMENT A
			WHERE A.PRO_CODE = @PRO_CODE
		END
		ELSE  --상세 세그정보가 없는 경우 FARE_GROUP정보를 채운다.
		BEGIN
			INSERT INTO RES_SEGMENT
			(
				RES_CODE,				SEQ_NO,					DEP_AIRPORT_CODE,		ARR_AIRPORT_CODE,
				DEP_CITY_CODE,			
				ARR_CITY_CODE,			
				AIRLINE_CODE,			NEW_CODE,				NEW_DATE,
				START_DATE,				
				END_DATE,				FLIGHT,					
				SEAT_STATUS			
			)
			SELECT
				@RES_CODE,				1,				A.DEP_DEP_AIRPORT_CODE,		A.DEP_ARR_AIRPORT_CODE,				
				(SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = A.DEP_DEP_AIRPORT_CODE) AS DEP_CITY_CODE,		
				(SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = A.DEP_ARR_AIRPORT_CODE) AS ARR_CITY_CODE,		
				A.AIRLINE_CODE,			@NEW_CODE,					GETDATE(),	
				CONVERT(DATETIME, (A.DEP_DEP_DATE + ' ' + A.DEP_DEP_TIME)),	
				CONVERT(DATETIME, A.DEP_ARR_DATE + ' ' + A.DEP_ARR_TIME),			
				SUBSTRING(A.DEP_FLT_NUMBER, 3, 4),				
				(CASE WHEN A.DEP_CFM_YN = 'Y' THEN 'HK' ELSE 'NN' END) AS SEAT_STATUS
			FROM FARE_GROUP A
			WHERE PRO_CODE = @PRO_CODE
			UNION ALL
			SELECT
				@RES_CODE,				2,				A.ARR_DEP_AIRPORT_CODE,		A.ARR_ARR_AIRPORT_CODE,				
				(SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = A.ARR_DEP_AIRPORT_CODE) AS DEP_CITY_CODE,		
				(SELECT CITY_CODE FROM PUB_AIRPORT WHERE AIRPORT_CODE = A.ARR_ARR_AIRPORT_CODE) AS ARR_CITY_CODE,		
				A.AIRLINE_CODE,			@NEW_CODE,					GETDATE(),		
				CONVERT(DATETIME, (A.ARR_DEP_DATE + ' ' + A.ARR_DEP_TIME)),			
				CONVERT(DATETIME, (A.ARR_ARR_DATE + ' ' + A.ARR_ARR_TIME)),		
				SUBSTRING(A.ARR_FLT_NUMBER, 3, 4),				
				(CASE WHEN A.DEP_CFM_YN = 'Y' THEN 'HK' ELSE 'NN' END) AS SEAT_STATUS
			FROM FARE_GROUP A
			WHERE PRO_CODE = @PRO_CODE
			SELECT * FROM FARE_GROUP
		END
	END
END
GO