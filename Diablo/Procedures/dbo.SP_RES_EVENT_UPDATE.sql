USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_RES_EVENT_UPDATE
- 기 능 : 할인예약정보수정
====================================================================================
	참고내용

====================================================================================
- 예제
 EXEC SP_RES_EVENT_UPDATE 'RP1102093477','9999999'
====================================================================================
	변경내역
====================================================================================
- 2011-02-01 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_RES_EVENT_UPDATE]
	@RES_CODE	RES_CODE,
	@NEW_CODE	char(7)
AS 
BEGIN
	
	--할인가격. 예약당시의 할인 가격 넣어줌
	DECLARE @EVT_ADT_PRICE INT 
	SELECT TOP 1 @EVT_ADT_PRICE = RE.EVT_ADT_PRICE 
		FROM PKG_EVENT  AS PE 
			INNER JOIN RES_EVENT AS RE 
				ON PE.PRO_CODE = RE.PRO_CODE 
	WHERE RE.RES_CODE = @RES_CODE
	
	
	IF @EVT_ADT_PRICE > 0 
	BEGIN
		--예약 할인적용 시켜준다. 할인적용시 포인트 쌓지 않도록 0 으로
		UPDATE RES_CUSTOMER 
		SET DC_PRICE  = SALE_PRICE - @EVT_ADT_PRICE  , POINT_PRICE = 0 ,POINT_YN = 'N', POINT_RATE = 0 
		WHERE RES_CODE = @RES_CODE
		AND SEQ_NO IN ( 1, 2 ) --무조건 두명만
	END 
END 
GO
