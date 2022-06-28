USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME						: ZP_DSR_REFUND_INSERT
■ DESCRIPTION					: DSR 환불 등록
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :

■ MEMO						    : 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-05-12		김성호			최초생성
   2022-06-02		김성호			등록만 가능하도록 요청
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[ZP_DSR_REFUND_INSERT]
	@TDNR			VARCHAR(10),	-- 티켓번호
	@DAIS			VARCHAR(6),		-- 접수일자
	@COBL			INT,			-- 
	@PEN			INT,
	@TAX			INT,
	@FEES			INT,
	@COAM			INT,
	@REMT			INT,
	@CRED			INT,
	@EMP_CODE		CHAR(7)
AS 
BEGIN
	--SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	IF NOT EXISTS(SELECT 1 FROM dbo.DSR_REFUND WHERE TICKET = @TDNR)
	BEGIN
		-- 등록
	    INSERT INTO dbo.DSR_REFUND
	      (
	        TICKET
	       ,REFUND_TYPE
	       ,REQUEST_DATE
	       ,FARE_USED_PRICE
	       ,FARE_REFUND_PRICE
	       ,CANCEL_CHARGE
	       ,TAX_REFUND1
	       ,COMM_REFUND
	       ,CASH_PRICE
	       ,CARD_PRICE
	       ,REFUND_PRICE
	       ,CUS_DATE
	       ,NEW_CODE
	       ,NEW_DATE
	      )
	    SELECT @TDNR AS [TICKET]
	          ,1 AS [REFUND_TYPE]
	          ,CONVERT(DATETIME ,@DAIS) AS [REQUEST_DATE]
	          ,(DT.NET_PRICE - @COBL) AS [FARE_USED_PRICE]
	          ,(DT.NET_PRICE - @PEN) AS [FARE_REFUND_PRICE]
	          ,@PEN AS [CANCEL_CHARGE]
	          ,(@TAX + @FEES) AS [TAX_REFUND1]
	          ,@COAM AS [COMM_REFUND]
	          ,@REMT AS [CASH_PRICE]
	          ,@CRED AS [CARD_PRICE]
	          ,(@REMT + @CRED) AS [REFUND_PRICE]
	          ,CONVERT(DATETIME ,@DAIS) AS [CUS_DATE]
	          ,@EMP_CODE AS [NEW_CODE]
	          ,GETDATE() AS [NEW_DATE]
	    FROM   DSR_TICKET DT
	    WHERE  DT.TICKET = @TDNR;
	END
	
	SELECT @@ROWCOUNT;

	
	--DECLARE @ROWCOUNT INT = 0
	
	---- 수정
	--UPDATE DR
	--SET    DR.REQUEST_DATE = CONVERT(DATETIME ,@DAIS)
	--        ,DR.FARE_USED_PRICE = (DT.NET_PRICE - @COBL)
	--        ,DR.FARE_REFUND_PRICE = (DT.NET_PRICE - @PEN)
	--        ,DR.CANCEL_CHARGE = @PEN
	--        ,DR.TAX_REFUND1 = (@TAX + @FEES)
	--        ,DR.COMM_REFUND = @COAM
	--        ,DR.CASH_PRICE = @REMT
	--        ,DR.CARD_PRICE = @CRED
	--        ,DR.REFUND_PRICE = (@REMT + @CRED)
	--        ,DR.CUS_DATE = CONVERT(DATETIME ,@DAIS)
	--        ,DR.EDT_CODE = @EMP_CODE
	--        ,DR.EDT_DATE = GETDATE()
	--FROM   dbo.DSR_REFUND DR
	--        INNER JOIN dbo.DSR_TICKET DT
	--            ON  DR.TICKET = DT.TICKET
	--WHERE  DR.TICKET = @TDNR;
	
	--SET @ROWCOUNT = @@ROWCOUNT;
	
	--IF @ROWCOUNT = 0
	--BEGIN
	--	-- 등록
	--    INSERT INTO dbo.DSR_REFUND
	--      (
	--        TICKET
	--       ,REFUND_TYPE
	--       ,REQUEST_DATE
	--       ,FARE_USED_PRICE
	--       ,FARE_REFUND_PRICE
	--       ,CANCEL_CHARGE
	--       ,TAX_REFUND1
	--       ,COMM_REFUND
	--       ,CASH_PRICE
	--       ,CARD_PRICE
	--       ,REFUND_PRICE
	--       ,CUS_DATE
	--       ,NEW_CODE
	--       ,NEW_DATE
	--      )
	--    SELECT @TDNR AS [TICKET]
	--          ,1 AS [REFUND_TYPE]
	--          ,CONVERT(DATETIME ,@DAIS) AS [REQUEST_DATE]
	--          ,(DT.NET_PRICE - @COBL) AS [FARE_USED_PRICE]
	--          ,(DT.NET_PRICE - @PEN) AS [FARE_REFUND_PRICE]
	--          ,@PEN AS [CANCEL_CHARGE]
	--          ,(@TAX + @FEES) AS [TAX_REFUND1]
	--          ,@COAM AS [COMM_REFUND]
	--          ,@REMT AS [CASH_PRICE]
	--          ,@CRED AS [CARD_PRICE]
	--          ,(@REMT + @CRED) AS [REFUND_PRICE]
	--          ,CONVERT(DATETIME ,@DAIS) AS [CUS_DATE]
	--          ,@EMP_CODE AS [NEW_CODE]
	--          ,GETDATE() AS [NEW_DATE]
	--    FROM   DSR_TICKET DT
	--    WHERE  DT.TICKET = @TDNR;
	    
	--    SET @ROWCOUNT = @@ROWCOUNT;
	--END
	
	--SELECT @ROWCOUNT;
END
GO
