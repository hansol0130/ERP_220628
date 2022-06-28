USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_PKG_MASTER_SYSTEM_QCHARGE
■ Description				: 행사마스터 기준 시스템 유류할증료 검색
■ Input Parameter			:                  
		@MASTER_CODE		: 마스터코드
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
	SELECT * FROM XN_PKG_MASTER_SYSTEM_QCHARGE('XXX111')
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2014-06-17		김성호			최초생성
	2014-07-03		김성호			시스템입력 유류할증료 백단위 절사
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_PKG_MASTER_SYSTEM_QCHARGE]
(	
	@MASTER_CODE	VARCHAR(10)
)
RETURNS TABLE
AS
RETURN
(
	WITH LIST AS
	(
		SELECT A.MASTER_CODE, A.AIRLINE_CODE, A.AIRPORT_CODE, C.NATION_CODE
		FROM PKG_MASTER A WITH(NOLOCK)
		INNER JOIN PUB_AIRPORT B WITH(NOLOCK) ON A.AIRPORT_CODE = B.AIRPORT_CODE
		INNER JOIN PUB_CITY C WITH(NOLOCK) ON B.CITY_CODE = C.CITY_CODE
		WHERE A.MASTER_CODE = @MASTER_CODE
	)
	SELECT TOP 1 A.MASTER_CODE, A.START_DATE AS [QCHARGE_DATE], A.ADT_QCHARGE, A.CHD_QCHARGE, A.INF_QCHARGE
	FROM (
		SELECT AA.MASTER_CODE, BB.START_DATE, 
			DBO.XN_PUB_PRICE_CUTTING(BB.ADT_QCHARGE, 3) AS [ADT_QCHARGE],
			DBO.XN_PUB_PRICE_CUTTING(BB.CHD_QCHARGE, 3) AS [CHD_QCHARGE],
			DBO.XN_PUB_PRICE_CUTTING(BB.INF_QCHARGE, 3) AS [INF_QCHARGE], BB.NEW_DATE, (CASE WHEN BB.END_DATE > GETDATE() THEN 1 ELSE 2 END) AS [TARGET_NUM]
		FROM LIST AA
		INNER JOIN AIRLINE_EXC_QCHARGE BB ON AA.AIRLINE_CODE = BB.AIRLINE_CODE
		WHERE BB.START_DATE <= GETDATE() AND (PATINDEX('%' + AA.AIRPORT_CODE + '%', BB.AIRPORT_CODES) > 0 OR PATINDEX('%' + AA.NATION_CODE + '%', BB.NATION_CODES) > 0)
		UNION ALL
		SELECT AA.MASTER_CODE, BB.START_DATE, 
			DBO.XN_PUB_PRICE_CUTTING(BB.ADT_QCHARGE, 3) AS [ADT_QCHARGE], 
			DBO.XN_PUB_PRICE_CUTTING(BB.CHD_QCHARGE, 3) AS [CHD_QCHARGE], 
			DBO.XN_PUB_PRICE_CUTTING(BB.INF_QCHARGE, 3) AS [INF_QCHARGE], BB.NEW_DATE, (CASE WHEN BB.END_DATE > GETDATE() THEN 1 ELSE 2 END) AS [TARGET_NUM]
		FROM LIST AA
		INNER JOIN AIRLINE_QCHARGE BB ON AA.AIRLINE_CODE = BB.AIRLINE_CODE
		INNER JOIN AIRLINE_REGION CC ON BB.AIRLINE_CODE = CC.AIRLINE_CODE AND BB.GROUP_SEQ = CC.GROUP_SEQ AND BB.REGION_SEQ = CC.REGION_SEQ
		WHERE BB.START_DATE <= GETDATE() AND (PATINDEX('%' + AA.AIRPORT_CODE + '%', CC.AIRPORT_CODES) > 0 OR PATINDEX('%' + AA.NATION_CODE + '%', CC.NATION_CODES) > 0)
		UNION ALL
		SELECT @MASTER_CODE, NULL, 0, 0, 0, NULL, 3
	) A
	ORDER BY A.TARGET_NUM, A.NEW_DATE DESC
)
GO
