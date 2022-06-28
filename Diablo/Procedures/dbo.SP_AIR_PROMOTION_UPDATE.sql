USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_AIR_PROMOTION_UPDATE
■ DESCRIPTION				: 항공 프로모션 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
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
CREATE PROC [dbo].[SP_AIR_PROMOTION_UPDATE]	
	@SEQ_NO INT,
	@TITLE VARCHAR(100),
	@SDATE DATETIME,
	@EDATE DATETIME,
	@DEP_SDATE DATETIME,
	@DEP_EDATE DATETIME,
	@LIMITED_DATE VARCHAR(500),
	@USE_YN CHAR(1),
	@EDT_CODE CHAR(7),
	@MIN_PAX_COUNT INT
	/*
	@AIRLINE_CODE CHAR(2),
	@AIRPORT_CODE VARCHAR(500),
	@CLASS VARCHAR(20),
	@SALE_PRICE INT,
	@SALE_COMM_RATE DECIMAL,
	*/	
AS 
BEGIN
	SET NOCOUNT ON;
	
	UPDATE AIR_PROMOTION SET
		TITLE = @TITLE,
		SDATE = @SDATE,
		EDATE = @EDATE,
		DEP_SDATE = @DEP_SDATE,
		DEP_EDATE = @DEP_EDATE,
		LIMITED_DATE = @LIMITED_DATE,
		USE_YN = @USE_YN,
		EDT_DATE = GETDATE(),
		EDT_CODE = @EDT_CODE,
		MIN_PAX_COUNT = @MIN_PAX_COUNT 
		/*
		AIRLINE_CODE = @AIRLINE_CODE,
		AIRPORT_CODE = @AIRPORT_CODE,
		CLASS = @CLASS,		
		SALE_PRICE = @SALE_PRICE,
		SALE_COMM_RATE = @SALE_COMM_RATE,
		*/
	WHERE SEQ_NO = @SEQ_NO;

	SELECT @SEQ_NO;
END

GO
