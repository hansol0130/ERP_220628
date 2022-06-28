USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
/*================================================================================================================    
■ USP_NAME				: [interface].[VACCCOUNT_DEPOSIT_INSERT]  
■ DESCRIPTION			: 예약 등록 및 수정 
■ INPUT PARAMETER		:     
■ OUTPUT PARAMETER		: 
■ EXEC					: RES_HTL_ROOM_MASTER

EXEC [dbo].[VACCOUNT_DEPOSIT_INSERT] 'RH2104290124', '','강찬희',1000

■ MEMO					: 오류 발생 시 @RES_CODE = NULL, @MESSAGE = 오류메세지
------------------------------------------------------------------------------------------------------------------    
■ CHANGE HISTORY
------------------------------------------------------------------------------------------------------------------    
	DATE			AUTHOR			DESCRIPTION               
------------------------------------------------------------------------------------------------------------------    
	2021-04-26		강찬희			최초생성
================================================================================================================*/     
CREATE PROC [dbo].[VACCOUNT_DEPOSIT_UPDATE] 

			@RESV_NO	VARCHAR(20),
			@TRANS_NO	VARCHAR(20) NULL,		
			@PAY_USER	VARCHAR(20) NULL,		
			@PRICE		INT

	
AS     


DECLARE		@PAY_TYPE				VARCHAR(100),
			@PAY_CURRENCY			VARCHAR(100),
			@CASH_ACCOUNT_BANK		VARCHAR(100),
			@CASH_ACCOUNT_NO		VARCHAR(100),
			@TRAN_NO				VARCHAR(100),
			@PAYMENT_ID				VARCHAR(100)

			
          
			SET @PAY_TYPE = 'VTAC';
			SET @PAY_CURRENCY = 'KRW';


BEGIN

    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    ------------------------------------------------------------------------
	-- 트리거 동작 제외
	------------------------------------------------------------------------
	SET CONTEXT_INFO 0x21884680;
	
    -- 리턴 변수
    --DECLARE @RES_CODE VARCHAR(20) = NULL, @CUS_NO INT = 0, @RESULT_CODE INT = 1, @MESSAGE NVARCHAR(2048) = NULL, @IN_DATE DATETIME = GETDATE();
    DECLARE @JGRESV_NO	INT, 
			@TOTAL_AMT  INT,
			@PAY_TOTAL  INT,
			@RESV_ID    VARCHAR(100),
			@ERR		INT,
			@RES_CODE   VARCHAR(10),
			@MESSAGE    VARCHAR(1000),
			@SQL		VARCHAR(2000)
    
	BEGIN TRY
		
		SELECT @JGRESV_NO = RESV_NO, @TOTAL_AMT = TOTAL_AMT, @RESV_ID = RESV_ID FROM HTL_RESV_MAST WHERE VGT_CODE = @RESV_NO;		


		SELECT		@CASH_ACCOUNT_BANK = BANK_NAME,
					@CASH_ACCOUNT_NO = BANK_ACCOUNT,
					@TRAN_NO = TRAN_NO,
					@PAYMENT_ID = PAYMENT_ID
		FROM [dbo].[HTL_RESV_VACCOUNT] WHERE RESV_NO =@JGRESV_NO 

		INSERT INTO HTL_RESV_PAY
		(
			RESV_NO,
			PAY_NO,
			PAY_TYPE,
			PAY_CURRENCY,
			PAY_TOTAL_AMOUNT,
			PAY_STATUS,
			PAY_DATE,
			PAY_USER,
			CARD_AMOUNT,
			CARD_NAME,
			CARD_NUM,
			CASH_AMOUNT,
			CASH_ACCOUNT_BANK,
			CASH_ACCOUNT_NO,
			CASH_PAY_NAME,
			CASH_PAY_DATE,
			CASH_RECEIPT_CONT,
			APP_NO,
			TRAN_NO,
			PAYMENT_ID,
			LAST_UPDATE_YN,
			LAST_UPDATE_DATE,
			LAST_UPDATE_USER,
			USE_YN,
			CONN_NO,
			SLIP_TARGET_YN,
			CASH_ACCOUNT_BANK_CODE
		)

		SELECT
			@JGRESV_NO,
			(SELECT ISNULL(MAX(PAY_NO),0) + 1 FROM HTL_RESV_PAY WHERE RESV_NO=@JGRESV_NO),
			@PAY_TYPE,
			@PAY_CURRENCY,
			@PRICE,
			'RMTK',
			GETDATE(),
			@PAY_USER,
			0,
			'',
			'',
			@PRICE,
			@CASH_ACCOUNT_BANK,
			@CASH_ACCOUNT_NO,
			@PAY_USER,
			GETDATE(),
			'',
			'',
			@TRAN_NO,
			@PAYMENT_ID,
			'Y',
			GETDATE(),
			'SYSTEM',
			'Y',
			'',
			'',
			''


		SELECT @PAY_TOTAL = SUM(PAY_TOTAL_AMOUNT)  FROM HTL_RESV_PAY WHERE RESV_NO = @JGRESV_NO;

		IF (@PAY_TOTAL >= @TOTAL_AMT)
			BEGIN 
				UPDATE HTL_RESV_MAST SET LAST_STATUS = 'RMTK' 
				WHERE RESV_NO = @JGRESV_NO
			END 

		SET @RES_CODE ='1';
		SET @MESSAGE ='정상처리완료';

		
    
    END TRY
	BEGIN CATCH
	
		SELECT @RES_CODE = '-1'; 
		SELECT @MESSAGE = ERROR_MESSAGE();

	END CATCH
	
	------------------------------------------------------------------------
	-- 결과리턴
	------------------------------------------------------------------------
	SELECT @RES_CODE AS [RES_CODE], @MESSAGE AS [MESSAGE], @RESV_ID AS [RESV_ID],@JGRESV_NO AS [JGRESV_NO];
	       
END
		   
GO
