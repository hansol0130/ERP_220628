USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_GET_PKG_MASTER_PRICE
■ Description				: 행사마스터 가격정보 검색
■ Input Parameter			:                  
		@PKG_MASTER			: 마스터코드
		@PRICE_SEQ			: 가격순번
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2014-06-17		김성호			최초생성
	2014-06-25		김성호			유류할증료 계산값만 노출
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_PKG_MASTER_PRICE]
(	
	@MASTER_CODE	VARCHAR(10),
	@PRICE_SEQ		INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT A.MASTER_CODE, A.PRICE_SEQ, A.PRICE_NAME, A.ADT_PRICE, A.CHD_PRICE, A.INF_PRICE, A.ADT_TAX, A.CHD_TAX, A.INF_TAX, A.QCHARGE_TYPE
		, (CASE A.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN B.ADT_QCHARGE ELSE A.ADT_QCHARGE END) AS [ADT_SALE_QCHARGE]
		, (CASE A.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN B.CHD_QCHARGE ELSE A.CHD_QCHARGE END) AS [CHD_SALE_QCHARGE]
		, (CASE A.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN B.INF_QCHARGE ELSE A.INF_QCHARGE END) AS [INF_SALE_QCHARGE]
		, (CASE A.QCHARGE_TYPE WHEN 0 THEN NULL WHEN 1 THEN B.QCHARGE_DATE ELSE A.QCHARGE_DATE END) AS [SALE_QCHARGE_DATE]
		, DBO.XN_PRO_SALE_PRICE_CUTTING(A.ADT_PRICE + A.ADT_TAX + (CASE A.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN B.ADT_QCHARGE ELSE A.ADT_QCHARGE END)) AS [ADT_SALE_PRICE]
		, DBO.XN_PRO_SALE_PRICE_CUTTING(A.CHD_PRICE + A.CHD_TAX + (CASE A.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN B.CHD_QCHARGE ELSE A.CHD_QCHARGE END)) AS [CHD_SALE_PRICE]
		, DBO.XN_PRO_SALE_PRICE_CUTTING(A.INF_PRICE + A.INF_TAX + (CASE A.QCHARGE_TYPE WHEN 0 THEN 0 WHEN 1 THEN B.INF_QCHARGE ELSE A.INF_QCHARGE END)) AS [INF_SALE_PRICE]
	FROM PKG_MASTER_PRICE A WITH(NOLOCK)
	LEFT JOIN XN_PKG_MASTER_SYSTEM_QCHARGE(@MASTER_CODE) B ON A.MASTER_CODE = B.MASTER_CODE
	WHERE A.MASTER_CODE = @MASTER_CODE AND A.PRICE_SEQ = CASE WHEN @PRICE_SEQ = 0 THEN A.PRICE_SEQ ELSE @PRICE_SEQ END
)
GO
