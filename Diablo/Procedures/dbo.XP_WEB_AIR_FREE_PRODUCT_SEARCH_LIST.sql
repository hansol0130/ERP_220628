USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_WEB_AIR_FREE_PRODUCT_SEARCH_LIST
■ DESCRIPTION				: 항공 스케쥴과 매칭되는 자유여행 상품 검색 
■ INPUT PARAMETER			:
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	XP_WEB_AIR_FREE_PRODUCT_SEARCH_LIST '2014-09-25' , '2014-09-30' , 'MNL' , '' 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-02-28		박형만			최초생성
   2014-10-01		김성호			행사마스터 SHOW_YN, ATT_CODE 조건 추가
   2015-08-10		김성호			사용 FN 수정
================================================================================================================*/ 
CREATE PROC [dbo].[XP_WEB_AIR_FREE_PRODUCT_SEARCH_LIST]
	@DEP_DEP_DATE DATETIME ,
	@ARR_ARR_DATE DATETIME ,

	@DEP_ARR_AIRPORT_CODE CHAR(3),
	@ARR_DEP_AIRPORT_CODE CHAR(3) 
AS 
BEGIN 

--DECLARE @DEP_DEP_DATE DATETIME ,
--@ARR_ARR_DATE DATETIME ,

--@DEP_ARR_AIRPORT_CODE CHAR(3),
--@ARR_DEP_AIRPORT_CODE CHAR(3) 

--SET @DEP_DEP_DATE = '2014-03-01' 
--SET @ARR_ARR_DATE = '2014-03-05' 
--SET @DEP_ARR_AIRPORT_CODE = 'BCN'
--SET @ARR_DEP_AIRPORT_CODE = NULL 
	SELECT TOP 100 * FROM 
	(
		SELECT 
			B.MASTER_CODE , B.PRO_CODE ,  C.PRICE_SEQ , B.PRO_NAME  , 
			B.TOUR_DAY , B.TOUR_NIGHT , 
			B.HOTEL_REMARK ,  (C.ADT_PRICE + DBO.XN_PRO_DETAIL_QCHARGE_PRICE(B.PRO_CODE)) AS ADT_PRICE , DBO.XN_PRO_DETAIL_QCHARGE_PRICE(B.PRO_CODE) AS QCHARGE_PRICE , --XN_PRO_GET_QCHARGE_PRICE
			A.DEP_DEP_DATE , A.DEP_DEP_TIME , A.ARR_ARR_DATE , A.ARR_ARR_TIME  ,
			A.DEP_ARR_AIRPORT_CODE , A.ARR_DEP_AIRPORT_CODE ,
			A.DEP_TRANS_CODE , (SELECT KOR_NAME FROM PUB_AIRLINE WITH(NOLOCK) WHERE AIRLINE_CODE = A.DEP_TRANS_CODE ) AS DEP_TRANS_NAME , 
			A.ARR_TRANS_CODE , (SELECT KOR_NAME FROM PUB_AIRLINE WITH(NOLOCK) WHERE AIRLINE_CODE = A.ARR_TRANS_CODE ) AS ARR_TRANS_NAME , 
			ABS(DATEDIFF(D, A.ARR_ARR_DATE , @ARR_ARR_DATE )) AS DIFF_DAY,
			CASE WHEN ARR_DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE THEN 1 ELSE 0 END  AS IS_ARR_CITY,   --귀국도시 매칭 여부 
			B.PKG_SUMMARY , 
			E.*   --사진정보 
		FROM PRO_TRANS_SEAT A  WITH(NOLOCK)
		INNER JOIN PKG_DETAIL B  WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE				--AND B.RES_ADD_YN = 'Y' 				AND B.SHOW_YN = 'Y' 
		INNER JOIN PKG_DETAIL_PRICE C  WITH(NOLOCK) ON B.PRO_CODE = C.PRO_CODE
		INNER JOIN PKG_MASTER D  WITH(NOLOCK) ON B.MASTER_CODE = D.MASTER_CODE				--AND D.SHOW_YN = 'Y'
		LEFT JOIN INF_FILE_MASTER E WITH(NOLOCK) ON D.MAIN_FILE_CODE = E.FILE_CODE
		WHERE A.DEP_DEP_DATE = @DEP_DEP_DATE
			--AND ARR_DEP_DATE = '2014-03-10'
			AND A.DEP_ARR_AIRPORT_CODE = @DEP_ARR_AIRPORT_CODE
			AND (A.ARR_DEP_AIRPORT_CODE = @ARR_DEP_AIRPORT_CODE  
				OR ISNULL(@ARR_DEP_AIRPORT_CODE,'') = '' )  --조건 맞아도 되고 안맞아도 되고(다구간만 해당)
			--AND ARR_DEP_AIRPORT_CODE = 'LIS'
			AND A.TRANS_TYPE = 1  --항공
			AND B.RES_ADD_YN = 'Y'
			AND B.SHOW_YN = 'Y' 
			AND D.SHOW_YN = 'Y'
			AND D.ATT_CODE = 'F'
	) TBL 
	ORDER BY IS_ARR_CITY DESC , DIFF_DAY ASC, ADT_PRICE ASC   -- 귀국도시 동일한순, 날짜 가까운순 , 가격순
END 
GO
