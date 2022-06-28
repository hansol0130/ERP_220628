USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
■ Function_Name				: XN_PKG_MASTER_PRICE_GROUP_COST_SUMMARY
■ Description				: 마스터코드로 공동경비 요약 검색
■ Input Parameter			:                  
		@MASTER_CODE		: 마스터코드
■ Output Parameter			: 
■ Output Value				: 
■ Exec						: 
	SELECT * FROM XN_PKG_MASTER_PRICE_GROUP_COST_SUMMARY('XXX000', 1)
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
	Date			Author			Description           
---------------------------------------------------------------------------------------------------
	2014-06-19		김성호			최초생성
-------------------------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[XN_PKG_MASTER_PRICE_GROUP_COST_SUMMARY]
(	
	@MASTER_CODE	VARCHAR(10),
	@PRICE_SEQ		INT
)
RETURNS TABLE
AS
RETURN
(
	WITH LIST AS
	(
		SELECT CURRENCY, SUM(ADT_COST) AS [ADT_COST], SUM(CHD_COST) AS [CHD_COST], SUM(INF_COST) AS [INF_COST]
		FROM PKG_MASTER_PRICE_GROUP_COST A
		WHERE A.MASTER_CODE = @MASTER_CODE AND A.PRICE_SEQ = @PRICE_SEQ
		GROUP BY CURRENCY
	)
	SELECT A.*
		, STUFF((
			SELECT ('/' +  COST_NAME) AS [text()]
			FROM PKG_MASTER_PRICE_GROUP_COST AA
			WHERE AA.MASTER_CODE = @MASTER_CODE AND AA.PRICE_SEQ = @PRICE_SEQ AND AA.CURRENCY = A.CURRENCY
			FOR XML PATH('')
		), 1, 1, '') AS [COST_NAME]
	FROM LIST A
)
GO
