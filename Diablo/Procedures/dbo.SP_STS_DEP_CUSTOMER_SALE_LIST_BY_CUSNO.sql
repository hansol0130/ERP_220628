USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_STS_DEP_CUSTOMER_SALE_LIST_BY_CUSNO
- 기 능 : 고객번호별 출발자 판매 통계 리스트 (투어캐빈4242807)
====================================================================================
	참고내용
====================================================================================
- 예제
 EXEC SP_STS_DEP_CUSTOMER_SALE_LIST_BY_CUSNO 0 , '2011-03-01' , '2011-03-31'  , 4242807 
====================================================================================
	변경내역
====================================================================================
- 2012-01-13 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_STS_DEP_CUSTOMER_SALE_LIST_BY_CUSNO]
	@SEARCH_TYPE INT,  -- 0 출발일 , 1 예약일
	@START_DATE VARCHAR(10), 
	@END_DATE VARCHAR(10),  -- 
	@CUS_NO INT 
AS 
SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
--DECLARE @SEARCH_TYPE INT,
--@START_DATE VARCHAR(10), 
--@END_DATE VARCHAR(10),
--@CUS_NO INT 
--SET @SEARCH_TYPE = 0 
--SET @START_DATE = '2011-03-01'
--SET @END_DATE = '2011-04-01'
--SET @CUS_NO =4242807 
	SELECT 
	ROW_NUMBER() OVER ( ORDER BY A.RES_CODE)  AS ROW_NUM,
		B.CUS_NO, A.RES_CODE,B.PRO_CODE, B.PRO_NAME, A.CUS_NAME, A.LAST_NAME, A.FIRST_NAME, A.NOR_TEL1, A.NOR_TEL2, A.NOR_TEL3
		, SALE_PRICE, CHG_PRICE, DC_PRICE, TAX_PRICE
		--, PENALTY_PRICE 
		, (SALE_PRICE - DC_PRICE + CHG_PRICE + TAX_PRICE )  AS TOTAL_PRICE 
	FROM RES_CUSTOMER_DAMO A
	INNER JOIN RES_MASTER_DAMO B ON A.RES_CODE = B.RES_CODE
	WHERE( (@SEARCH_TYPE = 0 AND B.DEP_DATE >= CONVERT(DATETIME,@START_DATE) AND B.DEP_DATE < CONVERT(DATETIME,@END_DATE) )
		OR (@SEARCH_TYPE = 1 AND B.NEW_DATE >= CONVERT(DATETIME,@START_DATE) AND B.NEW_DATE < CONVERT(DATETIME,@END_DATE) ))
		AND B.RES_STATE <= 7
		AND A.RES_STATE = 0 
		AND B.CUS_NO = @CUS_NO 
	ORDER BY A.RES_CODE
END 
GO
