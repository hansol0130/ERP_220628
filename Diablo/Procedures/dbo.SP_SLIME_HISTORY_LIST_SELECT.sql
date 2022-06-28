USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_SLIME_HISTORY_LIST_SELECT
■ DESCRIPTION				: 검색_히스토리페이지별목록
■ INPUT PARAMETER			: CUS_NO, PAGE_INDEX, PAGE_SIZE
■ EXEC						: 
    -- 
	DECLARE @TOTAL_COUNT INT
	exec SP_SLIME_HISTORY_LIST_SELECT 12048743, 1, 20, @TOTAL_COUNT OUTPUT
	SELECT @TOTAL_COUNT

■ MEMO						: 히스토리페이지별목록
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-07-27		IBSOLUTION				최초생성
   2017-10-21		IBSOLUTION				@TOTAL_COUNT 추가
   2017-12-04		IBSOLUTION				MASTER_NAME IS NOT NULL 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_SLIME_HISTORY_LIST_SELECT]
	@CUS_NO			INT,
	@PAGE_INDEX		INT,
	@PAGE_SIZE		INT,
	@TOTAL_COUNT	INT OUTPUT
AS
BEGIN

	SELECT @TOTAL_COUNT = COUNT(*) 
		FROM CUS_MASTER_HISTORY A WITH(NOLOCK)
		WHERE A.CUS_NO = @CUS_NO
			AND (A.HIS_TYPE <> 1 OR (A.HIS_TYPE = 1 AND A.MASTER_CODE <> ''))

	SELECT P1.* FROM (	
		SELECT ROW_NUMBER() OVER (ORDER BY A1.HIS_DATE DESC ) AS ROWNUM, * 
		FROM ( 	
			SELECT A.* , B.SUBJECT, C.EVT_NAME, D.MASTER_NAME, D.LOW_PRICE, E.*

				--(SELECT K.INT_SEQ FROM CUS_INTEREST K WITH(NOLOCK) WHERE K.CUS_NO = @CUS_NO AND K.PRO_CODE = A.MASTER_CODE) INTEREST
				
				/*관심상품 조인으로 변경*/
				,K.INT_SEQ AS INTEREST, K.PRO_CODE
				
				/*관광박수, 관광일수 가져옴 20191113*/
				, CASE 
					WHEN PD.TOUR_NIGHT IS NULL THEN DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(D.MASTER_CODE,1) 
					ELSE CONVERT(VARCHAR, PD.TOUR_NIGHT) END AS TOUR_NIGHT
				, ISNULL(PD.TOUR_DAY, D.TOUR_DAY) AS TOUR_DAY
				
				/*지역명 가져오기 20191113*/
				, STUFF((   
				  SELECT (','+PUB_VALUE) as [text()] FROM COD_PUBLIC WHERE PUB_TYPE = 'EVENT.REGION' AND  charindex(PUB_CODE ,C.SIGN_CODE  ) > 0    
				  FOR XML PATH('')), 1, 1, '') AS REGION_NAME  
				
				/*배너명 가져오기 20191113*/
				, C.BANNER_URL

				/*컨텐츠 이미지 가져오기 20191113*/
				, IFM1.REGION_CODE +'/'+  
				  IFM1.NATION_CODE +'/'+  
				  IFM1.STATE_CODE +'/'+  
				  IFM1.CITY_CODE +'/'+  
				  + CASE WHEN IFM1.FILE_TYPE = 1  THEN 'image' 
				  WHEN IFM1.FILE_TYPE = 2  THEN 'movie'  
				  WHEN IFM1.FILE_TYPE = 3 THEN 'document' 
				  ELSE 'image' END  + '/'  AS CONTENTS_PATH 

				, CASE WHEN ISNULL(IFM1.[FILE_NAME_S],'') ='' THEN IFM1.[FILE_NAME] + '.' + IFM1.EXTENSION_NAME  ELSE IFM1.[FILE_NAME_S] END AS SMALL_IMG 
				, CASE WHEN ISNULL(IFM1.[FILE_NAME_M],'') ='' THEN IFM1.[FILE_NAME] + '.' + IFM1.EXTENSION_NAME  ELSE IFM1.[FILE_NAME_M] END AS MIDDLE_IMG
				, CASE WHEN ISNULL(IFM1.[FILE_NAME_L],'') ='' THEN IFM1.[FILE_NAME] + '.' + IFM1.EXTENSION_NAME  ELSE IFM1.[FILE_NAME_L] END AS BIG_IMG  

				/*패키지코멘트*/
				, D.PKG_COMMENT

				/*패키지, 라르고 구분*/
				, D.BRAND_TYPE

				/*이벤트 상세 설명*/
				, C.EVT_DESC

				/*관련상품코드*/
				, STUFF((   
				  SELECT (', '+UPPER(MASTER_CODE)) as [text()] FROM PUB_EVENT_DATA WHERE EVT_SEQ = C.EVT_SEQ   
				  FOR XML PATH('')), 1, 1, '') AS DATA_MASTER 
  
				/*여행후기 카테고리구분*/
				, PM2.MASTER_CODE AS BOARD_MASTER_CODE
				, HC.CATEGORY_NAME AS BOARD_CATEGORY_NAME

				/*여행후기 지역명*/
				, B.REGION_NAME AS BOARD_REGION_NAME

				/*게시판에 매핑된 상품 이미지 가져오기*/
				, IFM2.REGION_CODE +'/'+  
				  IFM2.NATION_CODE +'/'+  
				  IFM2.STATE_CODE +'/'+  
				  IFM2.CITY_CODE +'/'+  
				  + CASE WHEN IFM2.FILE_TYPE = 1  THEN 'image' 
				  WHEN IFM2.FILE_TYPE = 2  THEN 'movie'  
				  WHEN IFM2.FILE_TYPE = 3 THEN 'document' 
				  ELSE 'image' END  + '/'  AS BOARD_CONTENTS_PATH 

				, CASE WHEN ISNULL(IFM2.[FILE_NAME_S],'') ='' THEN IFM2.[FILE_NAME] + '.' + IFM2.EXTENSION_NAME  ELSE IFM2.[FILE_NAME_S] END AS BOARD_SMALL_IMG 
				, CASE WHEN ISNULL(IFM2.[FILE_NAME_M],'') ='' THEN IFM2.[FILE_NAME] + '.' + IFM2.EXTENSION_NAME  ELSE IFM2.[FILE_NAME_M] END AS BOARD_MIDDLE_IMG
				, CASE WHEN ISNULL(IFM2.[FILE_NAME_L],'') ='' THEN IFM2.[FILE_NAME] + '.' + IFM2.EXTENSION_NAME  ELSE IFM2.[FILE_NAME_L] END AS BOARD_BIG_IMG  

				/*출발요일 표시*/
				, STUFF((   
				  SELECT (', '+UPPER(SEARCH_VALUE)) as [text()] FROM PKG_MASTER_SUMMARY WHERE MASTER_CODE = D.MASTER_CODE AND SEARCH_TYPE = 'W'   
				  FOR XML PATH('')), 1, 1, '') AS WEEK_DAY 

			FROM CUS_MASTER_HISTORY A WITH(NOLOCK)
			LEFT JOIN HBS_DETAIL B WITH(NOLOCK)
				ON A.MASTER_SEQ = B.MASTER_SEQ
				AND A.BOARD_SEQ = B.BOARD_SEQ
			LEFT JOIN PUB_EVENT C WITH(NOLOCK)
				ON A.EVT_SEQ = C.EVT_SEQ
			LEFT JOIN PKG_MASTER D WITH(NOLOCK)
				ON A.MASTER_CODE = D.MASTER_CODE
			LEFT JOIN INF_FILE_MASTER E WITH(NOLOCK) 
				ON D.MAIN_FILE_CODE = E.FILE_CODE 
				AND E.FILE_TYPE = 1
				AND E.SHOW_YN = 'Y'	

			/*기획상품 이미지 가져오기*/
			LEFT JOIN PKG_MASTER PM1 WITH(NOLOCK)
				ON PM1.MASTER_CODE = B.MASTER_CODE
			LEFT JOIN INF_FILE_MASTER IFM1 WITH(NOLOCK) 
				ON PM1.MAIN_FILE_CODE = IFM1.FILE_CODE 
				AND IFM1.FILE_TYPE = 1
				AND IFM1.SHOW_YN = 'Y'	

			/*관심상품 조인으로 변경*/
			LEFT JOIN CUS_INTEREST K WITH(NOLOCK) 
				ON K.CUS_NO = @CUS_NO AND K.PRO_CODE = A.MASTER_CODE

			/*관광박수, 관광일수 조인*/
			LEFT JOIN PKG_DETAIL PD WITH(NOLOCK) 
				ON K.PRO_CODE = PD.PRO_CODE

			/*여행후기 패키지/지역명 표시*/
			LEFT JOIN HBS_CATEGORY HC WITH(NOLOCK) 
				ON HC.MASTER_SEQ = B.MASTER_SEQ 
				AND HC.CATEGORY_SEQ = B.CATEGORY_SEQ

			/*여행후기 상품코드의 이미지 가져오기*/
			LEFT JOIN PKG_MASTER PM2 WITH(NOLOCK)
				ON PM2.MASTER_CODE = B.MASTER_CODE
			LEFT JOIN INF_FILE_MASTER IFM2 WITH(NOLOCK) 
				ON PM2.MAIN_FILE_CODE = IFM2.FILE_CODE 
				AND IFM2.FILE_TYPE = 1
				AND IFM2.SHOW_YN = 'Y'	

						
			WHERE A.CUS_NO = @CUS_NO
				AND (A.HIS_TYPE <> 1 OR (A.HIS_TYPE = 1 AND A.MASTER_CODE <> '' AND D.MASTER_NAME IS NOT NULL))
		) A1
	) P1
	WHERE P1.ROWNUM BETWEEN (@PAGE_INDEX - 1) * @PAGE_SIZE + 1 AND @PAGE_INDEX  * @PAGE_SIZE

END           

GO
