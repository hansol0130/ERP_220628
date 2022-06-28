USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_STS_DEP_CUSTOMER_SALE_LIST_BY_COM
- 기 능 : 판매처OR유입처별 실적 통계 리스트 (지마켓 @SALE_COM_CODE='91440' ,@PROVIDER=14  ) 
====================================================================================
	참고내용
	지마켓 출발자 실적 
====================================================================================
- 예제
 EXEC SP_STS_DEP_CUSTOMER_SALE_LIST_BY_COM 0 , '2011-03-01' , '2011-03-31' ,'91440', 14  
====================================================================================
	변경내역
====================================================================================
- 2012-01-13 박형만 신규 작성 
===================================================================================*/
CREATE PROC [dbo].[SP_STS_DEP_CUSTOMER_SALE_LIST_BY_COM]
	@SEARCH_TYPE INT,  -- 0 출발일 , 1 예약일
	@START_DATE VARCHAR(10), 
	@END_DATE VARCHAR(10),  -- 
	@SALE_COM_CODE VARCHAR(10) , --  판매업체, 0:전체    
	@PROVIDER INT  -- 유입처, -1:전체 
AS 
SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN 
--declare @SEARCH_TYPE INT,  -- 0 출발일 , 1 예약일
--	@START_DATE VARCHAR(10), 
--	@END_DATE VARCHAR(10),  -- 
--	@SALE_COM_CODE VARCHAR(10) , --  판매업체, 0:전체    
--	@PROVIDER INT  -- 유입처, -1:전체 
	
--SET @SEARCH_TYPE = 0 
--SET @START_DATE = '2011-03-01'
--SET @END_DATE = '2011-04-01'
--SET @SALE_COM_CODE ='91440'
--set @PROVIDER = 14  
	
	IF ( @SEARCH_TYPE = 0 )
	BEGIN
		SELECT 
		ROW_NUMBER() OVER ( ORDER BY DEP_DATE ,RES_CODE, PRO_CODE )  AS ROW_NUM
		, RES_CODE, PRO_CODE, DEP_DATE, NEW_DATE
		, DBO.FN_RES_GET_TOTAL_PRICE(RES_CODE) AS [TOTAL_PRICE]
		, DBO.FN_RES_GET_RES_COUNT(RES_CODE) AS [RES_COUNT], SALE_COM_CODE
		,(SELECT KOR_NAME FROM AGT_MASTER WHERE AGT_CODE = A.SALE_COM_CODE ) AS SALE_COM_NAME
		, PROVIDER
		FROM RES_MASTER A 
		WHERE( (@SEARCH_TYPE = 0 AND DEP_DATE >= CONVERT(DATETIME,@START_DATE) AND DEP_DATE < CONVERT(DATETIME,@END_DATE) )
			OR (@SEARCH_TYPE = 1 AND NEW_DATE >= CONVERT(DATETIME,@START_DATE) AND NEW_DATE < CONVERT(DATETIME,@END_DATE) ))
		AND (SALE_COM_CODE = @SALE_COM_CODE OR PROVIDER = @PROVIDER) 
		AND RES_STATE <= 7
		ORDER BY DEP_DATE ,RES_CODE, PRO_CODE
		
	END 
	ELSE 
	BEGIN 
		SELECT 
		ROW_NUMBER() OVER ( ORDER BY NEW_DATE)  AS ROW_NUM
		, RES_CODE, PRO_CODE, DEP_DATE, NEW_DATE
		, DBO.FN_RES_GET_TOTAL_PRICE(RES_CODE) AS [TOTAL_PRICE]
		, DBO.FN_RES_GET_RES_COUNT(RES_CODE) AS [RES_COUNT], SALE_COM_CODE
		,(SELECT KOR_NAME FROM AGT_MASTER WHERE AGT_CODE = A.SALE_COM_CODE ) AS SALE_COM_NAME
		, PROVIDER
		FROM RES_MASTER A 
		WHERE( (@SEARCH_TYPE = 0 AND DEP_DATE >= CONVERT(DATETIME,@START_DATE) AND DEP_DATE < CONVERT(DATETIME,@END_DATE) )
			OR (@SEARCH_TYPE = 1 AND NEW_DATE >= CONVERT(DATETIME,@START_DATE) AND NEW_DATE < CONVERT(DATETIME,@END_DATE) ))
		AND (SALE_COM_CODE = @SALE_COM_CODE OR PROVIDER = @PROVIDER) 
		AND RES_STATE <= 7
		ORDER BY NEW_DATE 
		
	END 
END 
GO
