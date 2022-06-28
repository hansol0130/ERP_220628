USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=================================================================================================
■ Database					: DIABLO
■ USP_Name					: SP_RES_AIR_DOM_PAY_LIST  
■ Description				: DSR 사용 안하는 국내 온라인 항공 TW , LJ 발권내역 조회 
■ Input Parameter			:                  
		@START_DTE			:
		@END_DTE			:
		@SEARCH_TYPE		:
		@ORDER_BY			:
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  
EXEC SP_RES_AIR_DOM_PAY_LIST @SEARCH_TYPE =1,@START_DATE ='2016-01-01' ,@END_DATE ='2016-02-01' ,@AIR_GDS = '103' 
EXEC SP_RES_AIR_DOM_PAY_LIST @SEARCH_TYPE =0,@START_DATE ='2016-01-01' ,@END_DATE ='2016-02-01' ,@AIR_GDS = '103' 


■ Author					: 박형만  
■ Date						: 2016-02-02
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
   2016-02-02       박형만			최초생성  
=================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_RES_AIR_DOM_PAY_LIST]    
	@SEARCH_TYPE INT,
	@START_DATE DATETIME ,
	@END_DATE DATETIME ,
	@AIR_GDS VARCHAR(20),
	@RES_STATE INT = 10
AS    
BEGIN    
  
--DECLARE @START_DATE DATETIME 
--DECLARE @END_DATE DATETIME 
--DECLARE @AIR_GDS VARCHAR(20)
--DECLARE @SEARCH_TYPE INT

--SET @START_DATE = '2016-01-01 00:00:00'
--SET @END_DATE = '2016-02-01 00:00:00'
--SET @AIR_GDS = '103'
--SET @SEARCH_TYPE = 0 ;


	-- 상세 
	IF( @SEARCH_TYPE = 0 )
	BEGIN
		SELECT * ,PAY_PRICE -TAX_PRICE AS FARE_PRICE
		FROM 
		(
			SELECT 
			A.PRO_CODE , 
			A.RES_CODE ,
			D.PAY_DATE , 
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE ) RES_CNT,
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 0 ) ADT_CNT,
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 1 ) CHD_CNT,
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 2 ) INF_CNT,
			A.RES_STATE ,
			A.NEW_DATE ,
			A.SYSTEM_TYPE , 
			B.AIR_GDS ,
			B.AIRLINE_CODE,
			B.PNR_CODE1 ,
			B.PNR_CODE2 ,
			B.DEP_DEP_AIRPORT_CODE +'-'+ B.DEP_ARR_AIRPORT_CODE AS DEP_ROUTE , 
			ISNULL(B.ARR_DEP_AIRPORT_CODE,'') +'-'+ ISNULL(B.ARR_ARR_AIRPORT_CODE,'') AS ARR_ROUTE,
			D.PAY_PRICE , 
			DBO.FN_RES_AIR_DOM_GET_TAX_PRICE(A.RES_CODE) AS TAX_PRICE,
			D.PAY_REMARK ,
			D.PAY_SEQ , 
			D.CXL_YN  AS PAY_CXL_YN ,
			D.CXL_DATE  AS PAY_CXL_DATE 
			----update d set d.ADMIN_REMARK = Damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', d.SEC_PAY_NUM)	 
			from RES_MASTER_damo A WITH(NOLOCK)
				INNER JOIN RES_AIR_DETAIL B  WITH(NOLOCK)
					ON A.RES_CODE = B.RES_CODE 
				INNER JOIN PAY_MATCHING C  WITH(NOLOCK)
					ON A.RES_CODE = C.RES_CODE 
				INNER JOIN PAY_MASTER_DAMO D  WITH(NOLOCK)
					ON C.PAY_SEQ = D.PAY_SEQ 
					AND (D.CXL_YN ='N' OR (B.AIR_GDS = 103 AND  D.CXL_YN ='Y') )  -- 진에어는 VOID 취소 포함
					AND D.PAY_TYPE = 10  -- ONLY CCCF  
			WHERE A.PRO_TYPE = 2 
			--AND B.AIR_GDS IN ( 101,102,103,104 )   --  진에어 103 , 티웨이 104  
			AND B.AIR_GDS IN (SELECT DATA FROM DBO.FN_SPLIT(@AIR_GDS,','))    -- 진에어 103 , 티웨이 104 
			and D.PAY_DATE > @START_DATE AND D.PAY_DATE < DATEADD(D,1,@END_DATE)
			AND A.SYSTEM_TYPE IN (1,3)  -- ONLY 웹예약
			AND (@RES_STATE = 10 OR A.RES_STATE = @RES_STATE )
		) T
		ORDER BY PAY_DATE , NEW_DATE 
	
	END 
	--일별 합산
	ELSE IF ( @SEARCH_TYPE = 1 )
	BEGIN
		SELECT PAY_DATE, SUM(RES_CNT) AS RES_CNT ,SUM(PAY_PRICE)  AS PAY_PRICE  , SUM(TAX_PRICE)   AS TAX_PRICE , SUM(PAY_PRICE) - SUM(TAX_PRICE)  AS FARE_PRICE FROM 
		(
			SELECT 
			CONVERT(VARCHAR(10),D.PAY_DATE ,121) PAY_DATE, 
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE ) RES_CNT,
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 0 ) ADT_CNT,
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 1 ) CHD_CNT,
			(SELECT COUNT(*) FROM RES_CUSTOMER_DAMO WHERE RES_CODE = A.RES_CODE AND AGE_TYPE = 2 ) INF_CNT,
			B.AIR_GDS ,
			B.AIRLINE_CODE,
			D.PAY_PRICE , 
			DBO.FN_RES_AIR_DOM_GET_TAX_PRICE(A.RES_CODE) AS TAX_PRICE, D.PAY_REMARK ,
			D.PAY_SEQ 
			----update d set d.ADMIN_REMARK = Damo.dbo.dec_varchar('DIABLO','dbo.PAY_MASTER','PAY_NUM', d.SEC_PAY_NUM)	 
			from RES_MASTER_damo A  WITH(NOLOCK)
				INNER JOIN RES_AIR_DETAIL B  WITH(NOLOCK)
					ON A.RES_CODE = B.RES_CODE 
				INNER JOIN PAY_MATCHING C  WITH(NOLOCK)
					ON A.RES_CODE = C.RES_CODE 
				INNER JOIN PAY_MASTER_DAMO D WITH(NOLOCK)
					ON C.PAY_SEQ = D.PAY_SEQ 
					AND (D.CXL_YN ='N' OR (B.AIR_GDS = 103 AND  D.CXL_YN ='Y') )  -- 진에어는 VOID 취소 포함
					AND D.PAY_TYPE = 10  -- ONLY CCCF 
			WHERE A.PRO_TYPE = 2 
			--AND B.AIR_GDS IN ( 101,102,103,104 )   --  진에어 103 , 티웨이 104  
			AND B.AIR_GDS IN (SELECT DATA FROM DBO.FN_SPLIT(@AIR_GDS,','))    -- 진에어 103 , 티웨이 104 
			and D.PAY_DATE > @START_DATE AND D.PAY_DATE < DATEADD(D,1,@END_DATE)
			AND A.SYSTEM_TYPE IN (1,3)  -- ONLY 웹예약
			AND (@RES_STATE = 10 OR A.RES_STATE = @RES_STATE )
		) T
		GROUP BY PAY_DATE 
		ORDER BY PAY_DATE  
	END 
END 

GO
