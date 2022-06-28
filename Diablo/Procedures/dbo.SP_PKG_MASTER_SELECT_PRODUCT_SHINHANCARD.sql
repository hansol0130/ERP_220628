USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_MASTER_SELECT_PRODUCT_SHINHANCARD
- 기 능 : 신한카드 연동상품 조회  
====================================================================================
	참고내용
====================================================================================
- 네이버 연동상품 조회 NaverShoppingProductMakeText.exe 스케쥴 프로그램에서 사용
	신한카드 여행 카테고리 상품 전송 전체EP전송 
- 예제
 EXEC SP_PKG_MASTER_SELECT_PRODUCT_SHINHANCARD 
 select top 100 * from pkg_master where master_code ='AFF111'
 select top 100 * from pkg_detail where master_code ='AFP155'
 and dep_date > getdate() 
====================================================================================
	변경내역
====================================================================================
- 2015-11-04 박형만 최초생성
===================================================================================*/
CREATE PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_SHINHANCARD]
	--@EXE_DATE DATETIME -- 실행일 
AS 
SET NOCOUNT ON 



SELECT * ,
	'/Affiliate/Product/PackageMaster?MasterCode=' + MASTER_CODE  AS PROD_URL ,
	CONTENTS_PATH  + COALESCE( MIDDLE_IMG , BIG_IMG , SMALL_IMG) AS IMAGE_URL
FROM 
	( 

	SELECT 
		UPPER(PM.MASTER_CODE)  AS MASTER_CODE,
		CASE WHEN SUBSTRING(PM.MASTER_CODE ,3,1) = 'F' THEN '2' ELSE '1' END AS MASTER_TYPE ,
		
		ISNULL(STUFF((
			SELECT (',' + ATT_TYPE_NAME ) AS [text()]
			FROM 
			(
				SELECT DISTINCT
					CASE 
					WHEN SUBSTRING(A.MASTER_CODE ,3,1) = 'G' THEN '골프여행'
					WHEN SUBSTRING(A.MASTER_CODE ,3,1) = 'W' THEN '허니문'
					WHEN SUBSTRING(A.MASTER_CODE ,3,1) = 'F' THEN '자유/배낭'
					WHEN SUBSTRING(A.MASTER_CODE ,3,1) = 'H' THEN '자유/배낭'
					WHEN SUBSTRING(A.MASTER_CODE ,3,1) = 'B' THEN '지방출발'
					WHEN B.BRANCH_CODE= 1  THEN '지방출발'
					WHEN A.ATT_CODE IN ('P','X','Y') THEN '패키지'
					WHEN A.ATT_CODE IN ('B','D','E','H','I','K','R','T','Z') THEN '자유/배낭'
					WHEN A.ATT_CODE IN ('W') THEN '허니문'
					--WHEN A.ATT_CODE IN ('G') THEN 'G'
					--WHEN A.ATT_CODE IN ('O') THEN 'O'
					WHEN A.ATT_CODE IN ('J') THEN '가족여행'
					WHEN A.ATT_CODE IN ('C') THEN '크루즈여행'
					ELSE '패키지' END AS ATT_TYPE_NAME 
				FROM PKG_ATTRIBUTE  A 
					INNER JOIN PKG_MASTER B 
						ON A.MASTER_CODE = B.MASTER_CODE 
					WHERE A.MASTER_CODE = PM.MASTER_CODE
				--ORDER BY 
			) T 
		FOR XML PATH('')), 1, 1, '') , '패키지') AS ATT_TYPE_NAME ,
	
		CASE WHEN PM.NEXT_DATE > DATEADD(DD,-1,GETDATE()) THEN CONVERT(VARCHAR(10),DATEADD(DD,-1,GETDATE()) ,121)
			ELSE CONVERT(VARCHAR(10),DATEADD(DD,-1,PM.NEXT_DATE) ,121)  END AS NEXT_DATE ,
		CASE WHEN PM.LAST_DATE IS NULL THEN CONVERT(VARCHAR(10),GETDATE())
			ELSE CONVERT(VARCHAR(10), DATEADD(DD, PM.TOUR_DAY ,PM.LAST_DATE) ,121) END AS LAST_DATE, --도착일까지는 전시

		PM.MASTER_NAME ,
		CASE WHEN ISNULL(PM.PKG_SUMMARY,'') = '' THEN PM.MASTER_NAME ELSE PM.PKG_SUMMARY END PKG_SUMMARY  ,

		'' AS PKG_KEYWORD ,
	
		PM.LOW_PRICE ,
		PM.HIGH_PRICE ,
		
		--CONVERT(VARCHAR,(CASE WHEN  ISNULL(DBO.FN_GET_TOUR_NIGHT(PM.MASTER_CODE , 0 ) ,0) > 0 
		--	THEN DBO.FN_GET_TOUR_NIGHT(PM.MASTER_CODE , 0 )  ELSE PM.TOUR_DAY - 1 END)) +'박 ' 
		--+ 
		--CONVERT(VARCHAR,ISNULL(PM.TOUR_DAY,0)) + '일' AS TOUR_DAY_TEXT,
		--DBO.FN_GET_TOUR_NIGHY_DAY_TEXT(PM.MASTER_CODE, 1) AS TOUR_DAY_TEXT2 ,

		CONVERT(VARCHAR,ISNULL(( SELECT TOP 1 TOUR_NIGHT FROM PKG_DETAIL WITH(NOLOCK) WHERE MASTER_CODE = PM.MASTER_CODE 
			AND SHOW_YN = 'Y'
			ORDER BY DEP_DATE DESC  ),0))+ '박 ' + 
		CONVERT(VARCHAR,ISNULL(( SELECT TOP 1 TOUR_DAY FROM PKG_DETAIL WITH(NOLOCK) WHERE MASTER_CODE = PM.MASTER_CODE 
			AND SHOW_YN = 'Y'
			ORDER BY DEP_DATE DESC  ),0))+ '일'  AS TOUR_DAY_TEXT ,
		'/CONTENT/' +  
		IFM.REGION_CODE +'/'+
		IFM.NATION_CODE +'/'+
		IFM.STATE_CODE +'/'+
		IFM.CITY_CODE +'/'+
		+ CASE WHEN IFM.FILE_TYPE = 1  THEN 'image'
			WHEN IFM.FILE_TYPE = 2  THEN 'movie'
			WHEN IFM.FILE_TYPE = 3 THEN 'document' 
		ELSE 'image' END  + '/'  AS CONTENTS_PATH ,
		IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME AS [FILE_NAME] , 
		CASE WHEN ISNULL(IFM.[FILE_NAME_S],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_S] END AS SMALL_IMG,
		CASE WHEN ISNULL(IFM.[FILE_NAME_M],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_M] END AS MIDDLE_IMG,
		CASE WHEN ISNULL(IFM.[FILE_NAME_L],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_L] END AS BIG_IMG,
	
		-- 제휴사 상품등록 제외 하거나 , 마스터 상품 보이지 않게 했을땐 판매중지
		CASE WHEN PM.SHOW_YN  = 'Y' AND PMA.USE_YN = 'Y' THEN '1' ELSE '2' END AS [STATUS] , 
		CASE WHEN PM.SIGN_CODE = 'K' THEN '1' ELSE '2' END AS NATION ,
	
		PM.SIGN_CODE , 
		PM.ATT_CODE ,
		CASE WHEN PM.SHOW_YN = 'Y' AND  PMA.USE_YN = 'Y' AND LAST_DATE > DATEADD(D,2,GETDATE()) THEN 'Y' ELSE 'N' END AS USE_YN 
	FROM PKG_MASTER AS PM WITH(NOLOCK)
		--G상품은 마스터 이미지정보 반드시 있어야함 - 사전공지 AND ERP 시스템 체크 
		INNER JOIN PKG_FILE_MANAGER AS PFM WITH(NOLOCK )
			ON PM.MASTER_CODE = PFM.MASTER_CODE
			AND PFM.FILE_CODE = ( SELECT TOP 1 S1.FILE_CODE FROM PKG_FILE_MANAGER AS S1 WITH(NOLOCK)
							INNER JOIN INF_FILE_MASTER AS S2 WITH(NOLOCK)
								ON S1.FILE_CODE = S2.FILE_CODE 
							WHERE S1.MASTER_CODE = PFM.MASTER_CODE 
							AND S2.SHOW_YN = 'Y'
							ORDER BY SHOW_ORDER ) 
		INNER JOIN INF_FILE_MASTER AS IFM WITH(NOLOCK)
			ON PFM.FILE_CODE = IFM.FILE_CODE
		
		INNER JOIN PKG_MASTER_AFFILIATE AS PMA WITH(NOLOCK)
			ON PM.MASTER_CODE = PMA.MASTER_CODE 
			AND PMA.PROVIDER = 15 -- 신한카드  

	--WHERE LAST_DATE > GETDATE()
	--WHERE PM.SHOW_YN = 'Y' 
) LIST  
 
GO
