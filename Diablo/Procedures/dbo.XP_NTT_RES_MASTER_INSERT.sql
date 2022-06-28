USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: [XP_NTT_RES_MASTER_INSERT]
■ DESCRIPTION				: 네이버 트립토파즈 예약 등록 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
	DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
	2021-12-20			김성호			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[XP_NTT_RES_MASTER_INSERT]
	@reservationNo		VARCHAR(20),
	@productFamilyId	VARCHAR(20),
	@productId			VARCHAR(20),
	@agencyProductId	VARCHAR(20),
	@bookingStatus		VARCHAR(20),
	@payStatus			VARCHAR(20),
	@bookingDate		DATETIME,
	@totalPerson		INT,
	@adult				INT,
	@child				INT,
	@infant				INT,
	@totalFare			INT,
	@payAmount			INT,
	@balanceAmount		INT,
	@addAmount			INT
AS 
BEGIN
	
	DECLARE @MASTER_CODE VARCHAR(10), @BIT_CODE VARCHAR(4), @PRO_CODE VARCHAR(20), @RES_CODE VARCHAR(20), @DEP_DATE DATETIME, @LAST_PAY_DATE DATETIME,
		@PRO_NAME NVARCHAR(100), @PRICE_SEQ INT, @COMM_RATE DECIMAL, @COMM_AMT DECIMAL, @NEW_CODE CHAR(7), @SALE_COM_CODE VARCHAR(10) = '93420' -- 네이버
	
	-- 신규 체크
	IF EXISTS(SELECT * FROM [dbo].[RES_ALT_MATCHING] WITH(NOLOCK) WHERE ALT_RES_CODE = @reservationNo)
	BEGIN
		-- 수정
		SELECT @RES_CODE = RES_CODE FROM dbo.RES_ALT_MATCHING WITH(NOLOCK) WHERE ALT_RES_CODE = @reservationNo
		
		UPDATE RES_MASTER_damo SET RES_STATE = (CASE @bookingStatus WHEN 'RSVCF' THEN 4 WHEN 'RSVCN' THEN 9 ELSE RES_STATE END), 
			EDT_CODE = NEW_CODE, EDT_DATE = GETDATE()
		WHERE RES_CODE = @RES_CODE
		
	END
	ELSE
	BEGIN
		-- 등록
		SELECT
			@MASTER_CODE = (CASE WHEN CHARINDEX('|', @productFamilyId) > 0 THEN SUBSTRING(@productFamilyId, 0, CHARINDEX('|', @productFamilyId)) ELSE @productFamilyId END),
			@BIT_CODE = (CASE WHEN CHARINDEX('|', @productFamilyId) > 0 THEN SUBSTRING(@productFamilyId, (CHARINDEX('|', @productFamilyId)+1), 4) ELSE '' END),
			@DEP_DATE = SUBSTRING(@productId, (CHARINDEX('-', @productId)+1), 8),
			@PRO_CODE = 
				((CASE WHEN CHARINDEX('|', @productFamilyId) > 0 THEN SUBSTRING(@productFamilyId, 0, CHARINDEX('|', @productFamilyId)) ELSE @productFamilyId END) + '-' +
				SUBSTRING(@productId, (CHARINDEX('-', @productId)+3), 6) +
				(CASE WHEN CHARINDEX('|', @productFamilyId) > 0 THEN SUBSTRING(@productFamilyId, (CHARINDEX('|', @productFamilyId)+1), 4) ELSE '' END)),
			@COMM_RATE = (SELECT COMM_RATE FROM AGT_MASTER WHERE AGT_CODE = @SALE_COM_CODE);
				
		SELECT @PRO_NAME = MIN(PD.PRO_NAME), @PRICE_SEQ = MAX(PDP.PRICE_SEQ), @NEW_CODE = MAX(PD.NEW_CODE), @LAST_PAY_DATE = DATEADD(dd, -14, @DEP_DATE),
			@COMM_AMT = @totalFare * 0.01 * @COMM_RATE 
		FROM PKG_DETAIL PD WITH(NOLOCK)
		INNER JOIN PKG_DETAIL_PRICE PDP WITH(NOLOCK) ON PD.PRO_CODE = PDP.PRO_CODE 
		WHERE PD.PRO_CODE = @PRO_CODE
		GROUP BY PD.PRO_CODE;
		
		-- 예약생성
		DECLARE @TMP_RES_CODE TABLE (RES_CODE VARCHAR(20));
		INSERT @TMP_RES_CODE
		EXEC DIABLO.DBO.XP_WEB_RES_MASTER_INSERT @RES_AGT_TYPE=0, @PRO_TYPE=1, @RES_TYPE=0,  @RES_PRO_TYPE=1, @PROVIDER=41, @RES_STATE=2, @RES_CODE=NULL,
			@MASTER_CODE=@MASTER_CODE, @PRO_CODE=@PRO_CODE, @PRICE_SEQ=@PRICE_SEQ, @PRO_NAME=@PRO_NAME, @DEP_DATE=@DEP_DATE, @ARR_DATE=@DEP_DATE, 
			@LAST_PAY_DATE=@LAST_PAY_DATE, @CUS_NO=1, @RES_NAME='고객1', @BIRTH_DATE=NULL, @GENDER=NULL, @IPIN_DUP_INFO=NULL, @RES_EMAIL=NULL, 
			@NOR_TEL1=NULL, @NOR_TEL2=NULL, @NOR_TEL3=NULL, @ETC_TEL1=NULL, @ETC_TEL2=NULL, @ETC_TEL3=NULL, @RES_ADDRESS1=NULL, @RES_ADDRESS2=NULL, @ZIP_CODE=NULL, 
			@MEMBER_YN='N', @CUS_REQUEST=NULL, @CUS_RESPONSE=NULL, @COMM_RATE=0.0, @COMM_AMT=@COMM_AMT, @NEW_CODE=@NEW_CODE, @ETC=NULL, @SYSTEM_TYPE=3,
			@SALE_COM_CODE=@SALE_COM_CODE, @TAX_YN='N';

		SELECT TOP 1 @RES_CODE = RES_CODE FROM @TMP_RES_CODE;
				
		-- 매핑테이블 등록
		INSERT INTO dbo.RES_ALT_MATCHING (RES_CODE, ALT_NAME, ALT_CODE, ALT_RES_CODE, NEW_CODE, NEW_DATE)
		VALUES (@RES_CODE, '네이버', 'NAVER', @reservationNo, @NEW_CODE, GETDATE());
		
	END

END
GO
