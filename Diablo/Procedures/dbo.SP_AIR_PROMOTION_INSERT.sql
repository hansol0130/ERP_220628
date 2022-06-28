USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_AIR_PROMOTION_INSERT
■ DESCRIPTION				: 항공 프로모션 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
SP_AIR_PROMOTION_INSERT '테스트', 'VGT', 'KE', 'KES,DMK', '2017-02-01 00:00:00', '2017-04-01 00:00:00', 's,d,d,d', 0, 3.7, 'Y', '9999999'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2017-02-10			정지용			최초생성
2017-08-25			정지용			프로모션 제한날짜 필드 추가
2019-07-23			박형만			최소적용 인원 추가
================================================================================================================*/ 
CREATE PROC [dbo].[SP_AIR_PROMOTION_INSERT]	
	@TITLE VARCHAR(100),
	@SITE_CODE VARCHAR(30),
	@AIRLINE_CODE CHAR(2),
	@AIRPORT_CODE VARCHAR(500),	
	@SDATE DATETIME,
	@EDATE DATETIME,
	@DEP_SDATE DATETIME,
	@DEP_EDATE DATETIME,
	@LIMITED_DATE VARCHAR(500),
	@CLASS VARCHAR(500),
	@SALE_PRICE INT,
	@SALE_COMM_RATE DECIMAL(18, 2),
	@USE_YN CHAR(1),
	@NEW_CODE CHAR(7),
	@MIN_PAX_COUNT INT 
AS 
BEGIN
	SET NOCOUNT OFF;
	INSERT INTO AIR_PROMOTION ( 
		TITLE, AIRLINE_CODE, AIRPORT_CODE, CLASS, SDATE, EDATE, DEP_SDATE, DEP_EDATE, SALE_PRICE, SALE_COMM_RATE, USE_YN, SITE_CODE, NEW_DATE, NEW_CODE, LIMITED_DATE , MIN_PAX_COUNT 
	)
	VALUES (
		@TITLE, @AIRLINE_CODE, @AIRPORT_CODE, @CLASS, @SDATE, @EDATE, @DEP_SDATE, @DEP_EDATE, @SALE_PRICE, @SALE_COMM_RATE, @USE_YN, @SITE_CODE, GETDATE(), @NEW_CODE, @LIMITED_DATE , @MIN_PAX_COUNT
	);

	SELECT @@IDENTITY;
END
GO
