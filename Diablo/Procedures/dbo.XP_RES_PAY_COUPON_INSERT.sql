USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_RES_PAY_COUPON_INSERT
■ DESCRIPTION				: 예약시 결제요청시 업체 쿠폰입력 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_RES_PAY_COUPON_INSERT 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-20		박형만			최초생성
================================================================================================================*/ 
create PROC [dbo].[XP_RES_PAY_COUPON_INSERT]
	@RES_CODE	RES_CODE,
	@AGT_CODE	VARCHAR(10),
	@CPN_NO		VARCHAR(200),
	@DEVICE_TYPE	CHAR(1),
	@CPN_TITLE	VARCHAR(200),
	@CPN_TYPE	CHAR(1),
	@DC_USE_PRICE	INT,
	@DC_MAX_PRICE	INT,
	@DC_DUP_YN	CHAR(1),
	@DC_MAIN_COM	CHAR(1),
	@DC_START_DATE	DATETIME,
	@DC_START_END	DATETIME,
	@PAY_TARGET_PRICE		INT,
	@DC_RATE		DECIMAL(4,2),
	@DC_PRICE		DECIMAL(12,2),
	@COMM_RATE	DECIMAL(4,2),
	@COMM_PRICE	DECIMAL(12,2),
	@NEW_CODE	EMP_CODE
AS 
BEGIN

	IF NOT EXISTS ( SELECT * FROM PAY_COUPON WITH(NOLOCK) WHERE RES_CODE = @RES_CODE AND CPN_NO = @CPN_NO  AND CXL_YN ='N')
	BEGIN

		DECLARE @CPN_SEQ INT 
		SET @CPN_SEQ = ISNULL((SELECT MAX(CPN_SEQ) FROM PAY_COUPON WITH(NOLOCK) WHERE RES_CODE = @RES_CODE) ,0) + 1 
		--결제 요청시 쿠폰금액 넣기 
		INSERT INTO PAY_COUPON
		(
			RES_CODE,AGT_CODE,CPN_NO,CPN_SEQ,
			DEVICE_TYPE,CPN_TITLE,CPN_TYPE,
			DC_USE_PRICE,DC_MAX_PRICE,DC_DUP_YN,DC_MAIN_COM,
			DC_START_DATE,DC_START_END,
			PAY_TARGET_PRICE,DC_RATE,DC_PRICE,
			COMM_RATE,COMM_PRICE,
			NEW_DATE , NEW_CODE,
			CXL_YN )
		VALUES 
		( 
			@RES_CODE,@AGT_CODE,@CPN_NO,@CPN_SEQ,
			@DEVICE_TYPE,@CPN_TITLE,@CPN_TYPE,
			@DC_USE_PRICE,@DC_MAX_PRICE,@DC_DUP_YN,@DC_MAIN_COM,
			@DC_START_DATE,@DC_START_END,
			@PAY_TARGET_PRICE,@DC_RATE,@DC_PRICE,
			@COMM_RATE,@COMM_PRICE,
			GETDATE() , @NEW_CODE ,
			'N'
		) 
	END 
	ELSE 
	BEGIN
		UPDATE PAY_COUPON 
		SET 	
		DEVICE_TYPE = @DEVICE_TYPE,
		CPN_TITLE = @CPN_TITLE,
		CPN_TYPE = @CPN_TYPE,
		DC_USE_PRICE = @DC_USE_PRICE,
		DC_MAX_PRICE = @DC_MAX_PRICE,
		DC_DUP_YN = @DC_DUP_YN,
		DC_MAIN_COM = @DC_MAIN_COM,
		DC_START_DATE = @DC_START_DATE,
		DC_START_END = @DC_START_END,
		PAY_TARGET_PRICE = @PAY_TARGET_PRICE,
		DC_RATE = @DC_RATE,
		DC_PRICE = @DC_PRICE,
		COMM_RATE = @COMM_RATE,
		COMM_PRICE = @COMM_PRICE,
		NEW_CODE = @NEW_CODE,
		NEW_DATE = GETDATE() 
		WHERE RES_CODE = @RES_CODE AND CPN_NO = @CPN_NO  
	END 
END 
GO
