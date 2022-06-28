USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*==================================================================================
	기본내용
====================================================================================
- SP 명 : SP_PKG_MASTER_SELECT_PRODUCT_NAVER
- 기 능 : 네이버 연동상품 조회 ( 전체EP전송 )
====================================================================================
	참고내용
====================================================================================
- 네이버 연동상품 조회 NaverShoppingProductMakeText.exe 스케쥴 프로그램에서 사용
	shopping.naver.com 여행 카테고리 상품 전송 전체EP전송 
- 예제
 EXEC SP_PKG_MASTER_SELECT_PRODUCT_NAVER 
====================================================================================
	변경내역
====================================================================================
- 2014-02-20 박형만 최초생성
===================================================================================*/
CREATE PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_NAVER]
	--@EXE_DATE DATETIME -- 실행일 
AS 
SET NOCOUNT ON 

--네이버 PROVIDER 코드 
DECLARE @PROVIDER_NAVER INT 
SET @PROVIDER_NAVER = 21 
------------------------------------------------------------------
--대상 마스터 코드 조회 및 임시 저장 
------------------------------------------------------------------
--대상 마스터 코드 테이블 
DECLARE @MASTER_CODE_TBL TABLE ( MASTER_CODE VARCHAR(20) ) 

--대상 마스터코드 조회 
INSERT INTO @MASTER_CODE_TBL
	--FROM PKG_AFF_LIST WHERE MAPID NOT IN ( SELECT MASTER_CODE FROM PKG_MASTER_AFFILIATE  WITH(NOLOCK) WHERE PROVIDER = 21  )   --없는것만 
SELECT PM.MASTER_CODE 
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
WHERE PM.LAST_DATE > GETDATE()
-- AND PM.NEXT_DATE > @EXE_DATE
AND PM.SHOW_YN  = 'Y' ;
--AND PM.MASTER_CODE NOT IN ( SELECT MASTER_CODE FROM PKG_MASTER_AFFILIATE  WITH(NOLOCK) WHERE PROVIDER = 21  )   --없는것만  
------------------------------------------------------------------
--제휴사 관리 테이블 수정및 등록 
------------------------------------------------------------------
--기존에있었지만.중지된것.제휴사 관리 테이블에 자동 사용안함으로 데이터 수정 
--SELECT * 
UPDATE A SET A.USE_YN = 'N' , A.EDT_DATE = GETDATE() , A.EDT_CODE = '9999999'
FROM PKG_MASTER_AFFILIATE  A 
	LEFT JOIN @MASTER_CODE_TBL B 
		ON A.MASTER_CODE = B.MASTER_CODE 
		AND A.PROVIDER = @PROVIDER_NAVER 
WHERE A.PROVIDER = @PROVIDER_NAVER 
AND A.USE_YN = 'Y' --기존 사용중인것
AND B.MASTER_CODE IS NULL ;

--기존에 없는 신규추가된것.제휴사 관리 테이블에 자동 데이터 입력 
INSERT INTO PKG_MASTER_AFFILIATE (MASTER_CODE , AFF_TYPE , NEW_DATE, NEW_CODE, USE_YN, PROVIDER)
SELECT MASTER_CODE, 5,  GETDATE() , '9999999' , 'Y' , @PROVIDER_NAVER  
FROM @MASTER_CODE_TBL 
WHERE MASTER_CODE NOT IN ( SELECT MASTER_CODE FROM PKG_MASTER_AFFILIATE  WITH(NOLOCK) WHERE PROVIDER = 21  );   --없는것만   

------------------------------------------------------------------
-- 대상 상품 조회 ( 제휴사 관리 테이블 기준  )
------------------------------------------------------------------
WITH PKG_AFF_LIST AS 
( 
	SELECT 
		UPPER(PM.MASTER_CODE)  AS MAPID,
		PM.MASTER_NAME  AS PNAME,
		PM.LOW_PRICE  AS PRICE ,
		'http://www.verygoodtour.com/Product/Package/PackageMaster.aspx?masterCode='+UPPER(PM.MASTER_CODE)  AS PGURL ,
		'/CONTENT/' +  
		IFM.REGION_CODE +'/'+
		IFM.NATION_CODE +'/'+
		IFM.STATE_CODE +'/'+
		IFM.CITY_CODE +'/'+
		+ CASE WHEN IFM.FILE_TYPE = 1  THEN 'image'
			WHEN IFM.FILE_TYPE = 2  THEN 'movie'
			WHEN IFM.FILE_TYPE = 3 THEN 'document' 
		ELSE 'image' END  + '/'  AS CONTENTS_PATH ,
		--IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME AS [FILE_NAME] , 
		CASE WHEN ISNULL(IFM.[FILE_NAME_S],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_S] END AS SMALL_IMG,
		CASE WHEN ISNULL(IFM.[FILE_NAME_M],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_M] END AS MIDDLE_IMG,
		CASE WHEN ISNULL(IFM.[FILE_NAME_L],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_L] END AS BIG_IMG,
		-------카테고리----------
		CASE WHEN PM.SIGN_CODE = 'K' THEN 'KOR' ELSE 'OVS' END AS CAID1 ,
		CASE WHEN PM.SIGN_CODE = 'K' THEN '국내여행' ELSE '해외여행' END AS CATE1 ,
		CASE WHEN PM.ATT_CODE IN ('P') THEN 'P' --패키지
			 WHEN PM.ATT_CODE IN ('F','E','J','K','L','O','S','T','V','X','Y','D','A') THEN 'F' --자유여행
			 WHEN PM.ATT_CODE IN ('H','Z') THEN 'H' --호텔팩
			 WHEN PM.ATT_CODE IN ('W') THEN 'W' --허니문
			 WHEN PM.ATT_CODE IN ('R') THEN 'R' --실시간항공
			 WHEN PM.ATT_CODE IN ('G') THEN 'G'--골프
			 WHEN PM.ATT_CODE IN ('I','B') THEN 'I'--에어텔(항공+호텔)
			 WHEN PM.ATT_CODE IN ('T') THEN 'T'--티켓
			 WHEN PM.ATT_CODE IN ('C') THEN 'C'--크루즈
			ELSE 'P' 
		END  AS CATE2 , --  그외 타입은 패키지
		(SELECT REGION_CODE FROM PUB_REGION WITH(NOLOCK) WHERE SIGN = PM.SIGN_CODE ) AS REGION_CODE,
		(SELECT KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE SIGN = PM.SIGN_CODE ) AS REGION_NAME ,
		PM.SIGN_CODE  --,
		--CASE WHEN PMA.MASTER_CODE IS NOT NULL THEN 'U' ELSE 'I' END AS CLASS  
		--PM.REGION_ORDER  
	FROM PKG_MASTER_AFFILIATE A 
		INNER JOIN PKG_MASTER AS PM WITH(NOLOCK)
			ON A.MASTER_CODE  = PM.MASTER_CODE 
			AND A.PROVIDER = @PROVIDER_NAVER 
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
	WHERE A.USE_YN = 'Y' -- 서비스 중인것 
)
SELECT 
A.MAPID,A.PNAME,A.PRICE,A.PGURL,'http://contents.verygoodtour.com' + CONTENTS_PATH  + SMALL_IMG AS IGURL, 
A.CAID1 AS CAID1 , 
A.CAID1 + '00' + A.CATE2 AS CAID2 ,
A.CAID1 + '00' + A.CATE2  + REGION_CODE AS CAID3 ,
'' AS CAID4 ,
CASE WHEN A.SIGN_CODE = 'K' THEN '국내여행' ELSE '해외여행' END AS CATE1 ,
CASE WHEN A.CATE2 = 'P' THEN '패키지' 
	 WHEN A.CATE2 = 'F' THEN '자유여행' 
	 WHEN A.CATE2 = 'H' THEN '호텔팩' 
	 WHEN A.CATE2 = 'W' THEN '허니문' 
	 WHEN A.CATE2 = 'R' THEN '실시간항공' 
	 WHEN A.CATE2 = 'G' THEN '골프' 
	 WHEN A.CATE2 = 'I' THEN '에어텔' 
	 WHEN A.CATE2 = 'T' THEN '티켓' 
	 WHEN A.CATE2 = 'C' THEN '크루즈' END AS CATE2, 
A.REGION_NAME AS CATE3,
'' CATE4,
'' AS MODEL ,
'좋은사람 좋은여행' AS BRAND ,
'참좋은여행' AS MAKER ,
'' AS ORIGI ,
'0' AS DELIV  
--'' AS EVENT, --기획전 이벤트 
--'' AS PCARD --무이자 할부 --SELECT * FROM PUB_CARD_INFO WHERE GETDATE() BETWEEN START_DATE AND END_DATE  
FROM 
(
	SELECT * FROM PKG_AFF_LIST 
) A ;
GO
