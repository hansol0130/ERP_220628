USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 /*================================================================================================================
 ■ USP_NAME						: ZP_MARKET_POINT_CARD_EXECUTE
 ■ DESCRIPTION						: 신용카드 결재 정상승인 후 해당 예약번호 SEQ 최대값 찾아서 포인트 처리 및 PAY_CARD_MARKET 테이블 POINT_NO 입력
 ■ INPUT PARAMETER					: 
 ■ OUTPUT PARAMETER			    : 
 ■ EXEC						    :
 ■ MEMO						    : 
 ------------------------------------------------------------------------------------------------------------------
 ■ CHANGE HISTORY                   
 ------------------------------------------------------------------------------------------------------------------
    DATE				AUTHOR			DESCRIPTION           
 ------------------------------------------------------------------------------------------------------------------  
    2020-08-10		홍종우			최초생성
    2022-04-26		오준혁			금액이 NULL 인 경우 수정
 ================================================================================================================*/ 
 CREATE PROC [dbo].[ZP_MARKET_POINT_CARD_EXECUTE]
 	@RES_CODE				CHAR(12)
 	
 AS 
 BEGIN
 	
 	SET NOCOUNT ON
 	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
 	DECLARE @TABLE_TEMP TABLE (
     CODE INT
     ,POINT_NO INT
     ,MESSAGE VARCHAR(4000)
 	)
 	
 	DECLARE @SEQ			INT
 	DECLARE @CUS_NO			INT
 	DECLARE @POINT_PRICE	MONEY
	DECLARE @PRO_CODE		VARCHAR(20)
	DECLARE @PRO_NAME		VARCHAR(100)
 	
 	-- 신용카드 결재 정상승인 후 해당 예약번호 SEQ 최대값 찾기
 	SELECT @SEQ = SEQ
 	      ,@CUS_NO = CUS_NO
 	      ,@POINT_PRICE = POINT_PRICE
 	FROM PAY_CARD_MARKET
 	WHERE RES_CODE = @RES_CODE
 	AND SEQ = (SELECT MAX(SEQ) 
 	           FROM PAY_CARD_MARKET
 			   WHERE RES_CODE = @RES_CODE)
 	AND POINT_NO IS NULL
 	
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
	
 	-- 포인트 사용
 	IF (ISNULL(@POINT_PRICE,0) > 0)
 	BEGIN 
 		INSERT @TABLE_TEMP
 		EXEC [interface].ZP_CUS_POINT_HISTORY_INSERT @CUS_NO, 1, @POINT_PRICE, @RES_CODE, @PRO_NAME, '', '9999999', 1, 0, @PRO_CODE
 	
 		-- PAY_CARD_MARKET에 POINT_NO 입력
 		UPDATE PAY_CARD_MARKET
 		SET POINT_NO = (SELECT POINT_NO FROM @TABLE_TEMP)
 		   ,EXE_DATE = GETDATE()
 		WHERE SEQ =@SEQ
 	END
 	
END
GO
