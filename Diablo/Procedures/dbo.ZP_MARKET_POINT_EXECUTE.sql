USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_MARKET_POINT_EXECUTE
■ DESCRIPTION					: 참좋은 마켓 포인트 유효성 체크 및 사용
■ INPUT PARAMETER				: 
	@CUS_NO			INT			: 고객번호
	@PAY_TYPE		INT			: 결제타입 1:신용카드(포인트 후처리) 2:가상계좌(포인트 선처리) 3:포인트 전액결제
	@POINT_PRICE	INT			: 사용포인트
■ OUTPUT PARAMETER			    : RETURN VALUE (1:TRUE, 0:FALSE)
■ EXEC						    :
■ MEMO						    : EXEC ZP_MARKET_POINT_EXECUTE 5095152, 1, 1000,
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2020-08-10		홍종우			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_MARKET_POINT_EXECUTE]
	@CUS_NO					INT,
	@PAY_TYPE				INT,
	@POINT_PRICE			INT,
	@RES_CODE				CHAR(12)
	
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @CUS_POINT		INT
	DECLARE @REMAIN_POINT	INT
	DECLARE @PRO_CODE		VARCHAR(20)
	DECLARE @PRO_NAME		VARCHAR(100)
	
	-- 해당 고객의 현재 총 포인트
	SET @CUS_POINT = (SELECT TOP 1 TOTAL_PRICE AS TOTAL_POINT
	FROM DBO.CUS_POINT WITH(NOLOCK)
	WHERE CUS_NO = @CUS_NO
	ORDER BY POINT_NO DESC)
	
	-- 해당 잔액
	SELECT @REMAIN_POINT = @CUS_POINT - @POINT_PRICE
	 
	-- PRO_CODE, PRO_NAME
	SELECT @PRO_CODE = A.PRO_CODE
	      ,@PRO_NAME = B.PRO_NAME
	FROM   MARKET_PRODUCT_TEMP A
	       INNER JOIN PKG_DETAIL B
	            ON  B.PRO_CODE = A.PRO_CODE
	WHERE  RES_CODE = @RES_CODE
	       AND SEQ = (
	               SELECT MAX(SEQ)
	               FROM   MARKET_PRODUCT_TEMP
	               WHERE  RES_CODE = @RES_CODE
	           )
	 
	-- 포인트 사용 유효성체크
	IF (@REMAIN_POINT < 0)
	BEGIN
		SELECT 0
		RETURN
	END
	
	-- 신용카드이면 PAY_CARD_MARKET 테이블 입력 
	-- 가상계좌,포인트 전액 결재면 포인트 사용
	IF (@PAY_TYPE = 1 AND @POINT_PRICE > 0)
	BEGIN
		INSERT INTO PAY_CARD_MARKET
		SELECT @CUS_NO, @POINT_PRICE, @RES_CODE, NULL, NULL, GETDATE()
	END
	ELSE IF (@POINT_PRICE > 0)
	BEGIN
		EXEC [interface].ZP_CUS_POINT_HISTORY_INSERT @CUS_NO, 1, @POINT_PRICE, @RES_CODE, @PRO_NAME, '', '9999999', 1, 0, @PRO_CODE
	END
		
	SELECT 1
END
GO
