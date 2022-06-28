USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME						: ZP_DHS_HOTEL_INVENTORY_HOLIDAY_LIST_SELECT
■ DESCRIPTION					: 조회_호텔재고및휴일_리스트
■ INPUT PARAMETER				: 
■ OUTPUT PARAMETER			    :
■ EXEC						    :
■ MEMO						    : 

EXEC [dbo].[ZP_DHS_HOTEL_INVENTORY_HOLIDAY_LIST_SELECT] 'RP2201127227' 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------  
   2022-01-21		오준혁			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[ZP_DHS_HOTEL_INVENTORY_HOLIDAY_LIST_SELECT]
	 @RES_CODE     VARCHAR(12)
AS 
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @SEARCH_WORD     VARCHAR(20)
	       ,@SDATE           DATE
	       ,@EDate           DATE
		   ,@MASTER_CODE     VARCHAR(10)
		   ,@BIT_CODE        VARCHAR(4)
		   ,@DEP_DATE        DATE


	SELECT @MASTER_CODE = MASTER_CODE
	      ,@DEP_DATE = DEP_DATE
	      ,@BIT_CODE = SUBSTRING(PRO_CODE, CHARINDEX('-', PRO_CODE)+7, LEN(PRO_CODE))
	FROM   dbo.RES_MASTER_damo
	WHERE  RES_CODE = @RES_CODE



	
	SELECT @SDATE = MIN(DEP_DATE)
	      ,@EDate = MAX(DEP_DATE)
	FROM   dbo.PKG_DETAIL
	WHERE  MASTER_CODE = @MASTER_CODE
	
	
	SET @SEARCH_WORD = (@MASTER_CODE + '-______' + @BIT_CODE)
	
	-- 예약정보
	SELECT @RES_CODE AS 'RES_CODE'
	      ,FORMAT(@DEP_DATE, 'yyyy-MM-dd') AS 'DEP_DATE'
	      ,FORMAT(@SDATE, 'yyyy-MM-01') AS 'SDATE'
	      ,DATEDIFF(MONTH, FORMAT(@SDATE, 'yyyy-MM-dd'), FORMAT(@EDate, 'yyyy-MM-dd')) AS 'DIFF_MONTH'
	
	-- 재고 리스트
	SELECT A.PRO_CODE
		  ,FORMAT(A.DEP_DATE, 'yyyy-MM-dd') AS 'DEP_DATE'
		  ,PDP.PRICE_SEQ
		  ,PDP.SGL_PRICE
		  ,A.RES_ADD_YN
		  ,A.MAX_COUNT
		  ,A.RES_COUNT
		  ,(CASE 
		         WHEN A.RES_ADD_YN = 'Y' AND A.MAX_COUNT > A.RES_COUNT THEN 'Y'
		         ELSE 'N'
		    END) AS RES_ADD_YN2
		  ,(A.MAX_COUNT - A.RES_COUNT) AS REST_RES_COUNT
	FROM   (
			   SELECT PD.PRO_CODE
			         ,PD.DEP_DATE
			         ,ISNULL(MAX(PD.MAX_COUNT) ,0) AS MAX_COUNT
			         ,MAX(PD.RES_ADD_YN) AS RES_ADD_YN
			         ,ISNULL(COUNT(*) ,0) AS RES_COUNT
			   FROM   dbo.PKG_MASTER PM
			          INNER JOIN dbo.PKG_DETAIL PD
			               ON  PM.MASTER_CODE = PD.MASTER_CODE
			          LEFT JOIN dbo.RES_MASTER_damo RM
			               ON  PD.PRO_CODE = RM.PRO_CODE
			                   AND RM.RES_STATE < 7
			   WHERE  PM.MASTER_CODE = @MASTER_CODE
			          AND PD.DEP_DATE >= @SDATE
			          AND PD.DEP_DATE < DATEADD(DAY ,1 ,@EDATE)
			          AND PD.PRO_CODE LIKE @SEARCH_WORD
			   GROUP BY
			          PD.PRO_CODE
			         ,PD.DEP_DATE
		   ) A
		   INNER JOIN dbo.PKG_DETAIL_PRICE PDP
				ON  A.PRO_CODE = PDP.PRO_CODE


	-- 휴일
	SELECT HOLIDAY
	      ,HOLIDAY_NAME
	FROM   dbo.PUB_HOLIDAY
	WHERE  HOLIDAY >= FORMAT(@SDATE ,'yyyy-MM-01')
	       AND HOLIDAY < DATEADD(MONTH ,1 ,FORMAT(@EDATE ,'yyyy-MM-01'))
	
	
END
GO
