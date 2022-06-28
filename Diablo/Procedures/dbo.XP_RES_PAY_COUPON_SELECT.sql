USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_RES_PAY_COUPON_SELECT
■ DESCRIPTION				: 업체 쿠폰조회 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_RES_PAY_COUPON_SELECT 'RT1708015266'  ,0 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-04-21		박형만			최초생성
   2017-08-02		박형만			최대할인금액 계산추가 (DC_PRICE 만)
================================================================================================================*/ 
CREATE PROC [dbo].[XP_RES_PAY_COUPON_SELECT]
	@RES_CODE	RES_CODE,
	@PAY_TARGET_PRICE INT = 0 


AS 
BEGIN
	
	--결제금액이 있을경우 
	-- 최신으로 (결제금액은 항상 변동될수 있으므로) 
	IF( @PAY_TARGET_PRICE > 0 )
	BEGIN
		UPDATE PAY_COUPON 
		SET PAY_TARGET_PRICE = @PAY_TARGET_PRICE 
		WHERE RES_CODE = @RES_CODE 
	END 
	--ELSE  -- 결제 금액이 0이면 기존에 최초에 등록된 요금을 사용 
	--BEGIN
	--	--쿠폰 조회 
	--	SELECT TOP 1 @PAY_TARGET_PRICE = PAY_TARGET_PRICE 
	--	FROM PAY_COUPON WITH(NOLOCK)
	--	WHERE RES_CODE = @RES_CODE 
	--END 

	--쿠폰 조회 
	SELECT RES_CODE,AGT_CODE,CPN_NO,CPN_SEQ,
		DEVICE_TYPE,CPN_TITLE,CPN_TYPE,
		DC_USE_PRICE,DC_MAX_PRICE,DC_DUP_YN,DC_MAIN_COM,
		DC_START_DATE,DC_START_END,
		PAY_TARGET_PRICE,DC_RATE,DC_PRICE,
		CASE WHEN DC_RATE  > 0 THEN  
			--CASE WHEN  DC_MAX_PRICE > 0 AND PAY_TARGET_PRICE * (DC_RATE * 0.01) > DC_MAX_PRICE THEN DC_MAX_PRICE ELSE PAY_TARGET_PRICE * (DC_RATE * 0.01) END   -- !!DC_RATE 는 예외 
			PAY_TARGET_PRICE * (DC_RATE * 0.01) 
			ELSE 
			-- 최대할인금액이 있고 최대할인금액보다 크면 최대할인금액으로 
			CASE WHEN  DC_MAX_PRICE > 0 AND DC_PRICE > DC_MAX_PRICE THEN DC_MAX_PRICE ELSE DC_PRICE END 
			END AS DC_CALC_PRICE ,  -- 계산된 총 할인금액 (수수료포함)
		COMM_RATE,COMM_PRICE,
		CASE WHEN COMM_RATE > 0 THEN  
			(CASE WHEN DC_RATE  > 0 THEN  PAY_TARGET_PRICE * (DC_RATE * 0.01) ELSE DC_PRICE END) /*계산된수수료*/ * (COMM_RATE * 0.01)   -- 여행사 부담율 
		ELSE COMM_PRICE END AS COMM_CALC_PRICE ,  --계산된 여행사 부담 수수료 
		NEW_DATE , NEW_CODE , CXL_YN , CXL_DATE 
	FROM PAY_COUPON WITH(NOLOCK)
	WHERE RES_CODE = @RES_CODE
	AND CXL_YN ='N' 
END 

GO
