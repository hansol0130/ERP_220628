USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<박형만>
-- Create date: <Create Date,2016-02-03 ,>
-- Description:	예약번호의 총 항공 TAX(제세공과금구함)
-- =============================================
CREATE FUNCTION [dbo].[FN_RES_AIR_DOM_GET_TAX_PRICE]
(
	@RES_CODE	RES_CODE
)
RETURNS INT
AS
BEGIN
	DECLARE @RESULT INT;

	DECLARE @BASE_TAX INT -- 기준 공항 이용료 
	SET @BASE_TAX = 4000 -- 편도 

	SELECT @RESULT= SUM(TAX_PRICE)
	FROM 
	(
		SELECT  
			--출발 
			--성인
			(CASE WHEN A.AGE_TYPE = 0 THEN 
				--진에어 
				CASE WHEN B.AIRLINE_CODE = 'LJ' THEN 
					CASE WHEN C.DEP_DC_CODE <> 'ADT' THEN @BASE_TAX / 2  ELSE @BASE_TAX END  -- ADT 제외 전부 50% 
				WHEN B.AIRLINE_CODE = 'TW' THEN 
					CASE WHEN C.DEP_DC_CODE IN ( 'PA','PO','RR','RA','RD','ZZ','RG') THEN  @BASE_TAX / 2 ELSE @BASE_TAX END 
				WHEN B.AIRLINE_CODE = 'KE' THEN 
					CASE WHEN C.DEP_DC_CODE IN ( 'TDD') THEN  @BASE_TAX / 2 ELSE @BASE_TAX END 
				WHEN B.AIRLINE_CODE = 'OZ' THEN 
					CASE WHEN C.DEP_DC_CODE IN ( 'AA') THEN  @BASE_TAX ELSE @BASE_TAX END 
				END 
			WHEN A.AGE_TYPE = 1 THEN @BASE_TAX / 2  
			WHEN A.AGE_TYPE = 2 THEN 0 
			END )
			+
			--도착
			CASE WHEN ISNULL(B.ARR_ARR_AIRPORT_CODE,'') <> '' THEN 
				(CASE WHEN A.AGE_TYPE = 0 THEN 
					--진에어 
					CASE WHEN B.AIRLINE_CODE = 'LJ' THEN 
						CASE WHEN C.ARR_DC_CODE <> 'ADT' THEN @BASE_TAX / 2  ELSE @BASE_TAX END  -- ADT 제외 전부 50% 
					WHEN B.AIRLINE_CODE = 'TW' THEN 
						CASE WHEN C.ARR_DC_CODE IN ( 'PA','PO','RR','RA','RD','ZZ','RG') THEN  @BASE_TAX / 2 ELSE @BASE_TAX END 
					WHEN B.AIRLINE_CODE = 'KE' THEN 
						CASE WHEN C.ARR_DC_CODE IN ( 'TDD') THEN  @BASE_TAX / 2 ELSE @BASE_TAX END 
					WHEN B.AIRLINE_CODE = 'OZ' THEN 
						CASE WHEN C.ARR_DC_CODE IN ( 'AA') THEN  @BASE_TAX ELSE @BASE_TAX END 
					END 
				WHEN A.AGE_TYPE = 1 THEN @BASE_TAX / 2  
				WHEN A.AGE_TYPE = 2 THEN 0 
				END ) ELSE 0 END  AS TAX_PRICE 
		FROM RES_CUSTOMER_DAMO A 
			INNER JOIN RES_AIR_DETAIL B 
				ON A.RES_CODE = B.RES_CODE 
			LEFT JOIN RES_AIR_CUSTOMER_DETAIL C 
				ON A.RES_CODE = C.RES_CODE 
				AND A.SEQ_NO = C.SEQ_NO 
			
		WHERE A.RES_CODE = @RES_CODE --AND A.AGE_TYPE = 0 
	) T 
	RETURN @RESULT

------------------------------------------------------------------------------
-- 티웨이 2016-02-03 현재 
-- 공항세 할인코드 
--'PA','PO','RR','RA','RD','ZZ','RG'
/*
CD	경로우대 - 항공운임10%
JU	제주도민 (성인) - 항공운임15%
PR	장애인(1-4급본인) - 항공운임
	PA	장애인(1-3급 동반보호자) - 항공운임,공항시설사용료50%
	PO	장애인(5-6급본인) - 공항시설사용료50%
NN	국가 유공자 - 항공운임50%
ND	독립유공자 - 항공운임50%
NA	독립유공자 동반 보호자 1명 - 항공운임50%
	RR	1-7급 국가 유공 상이자 본인 - 항공운임,공항시설사용료50%
	RA	1-3급 국가 유공 상이자의 동반자 1명 - 항공운임,공항시설사용료50%
	RD	5.18민주화운동 부상자 - 항공운임,공항시설사용료50%
	ZZ	제주도민+장애 5~6급 - 항공운임10%,공항시설사용료50%
MM	해군제주방어 사령부 - 항공운임10%
	RG	숙련기술 장려자 및 기능대회 입상자 - 공항시설사용료50%
*/ 
-- 아시아나 현재 
-- 공항세 할인 알수 없음 
/*
<option value="AA">[성인]성인</option>
<option value="CJ">[성인]제주도민 할인(10%)/제주노선 한정</option>
<option value="ME">[성인]군인할인(10%)</option>
<option value="SY">[성인]만 65세 이상(10%)</option>
<option value="IP">[성인]국가유공자할인(30%)</option>
<option value="NA">[성인]고엽제 후유증 할인</option>
<option value="IM">[성인]국가유공상이자/독립유공자/상이군경(50%)</option>
<option value="PA">[성인]국가유공상이자의 가족보호자할인(50%)</option>
<option value="PB">[성인]1~3급 장애인의 보호자할인(50%)</option>
<option value="PE">[성인]장애인할인(50%)</option>
<option value="NE">[성인]국가 유공 상이자 1-3급 동반가족 1인</option>*/------------------------------------------------------------------------------

END

GO
