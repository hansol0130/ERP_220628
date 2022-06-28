USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SELECT_PRODUCT_EST
■ DESCRIPTION				: 11번가 상품연동
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_PKG_MASTER_SELECT_PRODUCT_EST ''
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2015-12-03			정지용			최초생성
2015-12-22			정지용			약관URL 수정
2015-01-13			정지용			11번가 고정 상품추가..(JPP628, JPP613, JPC614, IPP603, EPP439, EPP4310, CPP861, CPP345, CPP344, APP128, APP127, APP0506)
2015-01-25			정지용			상품다시 원복
2015-02-29			정지용			서버에서 255MB 넘어갈 시 다운로드가 안되는 현상으로 인해 출발일 +8개월 인 상품만 조회
2016-05-24			정지용			11번가 모바일 리뉴로 인해 항목 추가
2017-03-24			정지용			11번가 카테고리 수정
2018-08-21			박형만			대기예약,좌석없는건 나오지 않도록수정 
2018-11-05			김남훈			쇼핑횟수 추가 Erp 4622건, avrgStmt 오타 수정
2021-03-11			김영민			11번가요청으로 출발일 +12개월상품조회로 변경
2021-10-15			김영민			11번가요청으로 (prdDetailInfo 상품상세/mealCount 식사횟수/tipYn 팁포함여부)추가
2022-01-05			오준혁           tipYn => guideFeeYn 수정
2022-02-17			김성호			확보좌석 최대 수 수정 (99->30)
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_EST]	
	@MASTER_CODE VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @PROVIDER_EST INT 
	SET @PROVIDER_EST = 31;
	
	SELECT '' AS selMnbdNckNm
	      ,B.AFF_CATE_CODE AS dispCtgrNo
	      ,RTRIM(A.MASTER_NAME) AS prdNm
	      ,A.MASTER_CODE AS sellerPrdCd
	      ,'01' AS suplDtyfrPrdClfCd	-- 부가세/면세상품코드 01:과세상품| 02:면세상품 | 03:영세상품
	      ,A.CONTENTS_PATH + COALESCE(CASE WHEN FILE_EXTENSION_NAME = 'BMP' THEN A.SMALL_IMG ELSE A.MIDDLE_IMG END ,A.BIG_IMG ,A.SMALL_IMG) AS prdImage01
	      ,--A.CONTENTS_PATH + [FILE_NAME] AS prdImage01,
	       '' AS prdImage02
	      ,'' AS prdImage03
	      ,'' AS prdImage04
	      ,'' AS htmlDetail
	      ,'N' AS selTermUseYn	-- 판매기간 설정
	      ,'' AS selPrdClfCd	-- # 판매기간코드(판매기간 'Y' 경우 필수)
	      ,'' AS aplBgnDy	-- # 판매 시작일(판매기간 'Y' 경우 필수)
	      ,'' AS aplEndDy	-- # 판매 종료일(판매기간 'Y' 경우 필수)
	      ,--'Y' AS selTermUseYn, -- 판매기간 설정 (1월6일에 "N"으로 고쳐야함)
	       --'0:100' AS selPrdClfCd, -- # 판매기간코드(판매기간 'Y' 경우 필수) (1월6일에 ""으로 고쳐야함)
	       --'2016/01/06' AS aplBgnDy, -- # 판매 시작일(판매기간 'Y' 경우 필수) (1월6일에 ""으로 고쳐야함)
	       --'2016/01/07' AS aplEndDy, -- # 판매 종료일(판매기간 'Y' 경우 필수) (1월6일에 ""으로 고쳐야함)
	       A.LOW_PRICE AS selPrc
	      ,A.HIGH_PRICE AS selMaxPrc
	      ,'N' AS cuponcheck	-- 기본즉시할인 설정여부(Y:설정 | N:설정안함 | S:기본값유지(상품수정)
	      ,'' AS dscAmtPercnt	-- # 기본즉시할인 설정시 설정
	      ,'' AS cupnDscMthdCd	-- # 기본즉시할인 설정시 설정
	      ,'' AS cupnUseLmtDyYn	-- # 기본즉시할인 설정시 설정
	      ,'' AS cupnIssEndDy	-- # 기본즉시할인 설정시 설정
	      ,'N' AS pointYN	-- 포인트 지급설정
	      ,'' AS pointValue	-- # 포인트 지급설정시 설정
	      ,'' AS spplWyCd	-- # 포인트 지급설정시 설정
	      ,'N' AS ocbYN	-- OK캐시백 지급 설정
	      ,'' AS ocbValue	-- #OK캐시백 지급설정시 설정
	      ,'' AS ocbWyCd	-- #OK캐시백 지급설정시 설정
	      ,'N' AS mileageYN	-- 마일리지 지급설정
	      ,'' AS mileageValue	-- # 마일리지 지금설정시 설정
	      ,'' AS mileageWyCd	-- # 마일리지 지금설정시 설정
	      ,'N' AS intFreeYN	-- 무이자 할수 제공 설정
	      ,'' AS intfreeMonClfCd	-- # 무이자 할수 제공 설정시 설정
	      ,'N' AS hopeShpYn	-- 희망후원 설정
	      ,'' AS hopeShpPnt	-- # 희망후원 설정시 설정
	      ,'' AS hopeShpWyCd	-- # 희망후원 설정시 설정
	      ,'N' AS prcCompExpYn	-- 가격비교사이트 설정
	      ,'29' AS prdTypCd	-- 상품 구분코드( 여행내재화상품 29 고정)
	      ,CONVERT(VARCHAR(10) ,A.NEXT_DATE ,111) AS prdSvcBgnDy	-- 최초 출발일
	      ,CONVERT(VARCHAR(10) ,A.LAST_DATE ,111) AS prdSvcEndDy	-- 마지막 출발일
	      ,'Y' AS drcStlYn	-- 즉시결제여부
	      ,'Y' AS htmlDetailIframeYn	-- iframe으로 호출하는지의 여부
	      ,'00' AS svcAreaCd
	      ,'N' AS penaltyApplyYn
	      ,'N' AS directStlYn
	      ,'' AS promotionFlag
	      ,A.ATT_TYPE_NAME AS tourPrdType
	      ,A.NATION_TYPE AS tourNationType
	      ,A.TOUR_NIGHT AS tourNightDays
	      ,A.TOUR_DAY AS tourDays
	      ,A.DEP_NATION AS departCountry
	      ,A.DEP_CITY AS departCity
	      ,A.ARR_NATION AS arrivalCountry
	      ,A.ARR_CITY AS arrivalCity
	      ,'' AS passStops	-- 여행지 정보 (선택)
	      ,'' AS avrtStmt	-- 추후에 상품명에서 대괄호 안에있는 문구 뽑아서 할 예정
	      ,'I' AS dtlsDescTyp -- I : 아이프레임 / H : HTML
	FROM   (
	           SELECT UPPER(PM.MASTER_CODE) AS MASTER_CODE
	                 ,CONVERT(CHAR(150) ,UPPER(PM.MASTER_NAME)) AS MASTER_NAME
	                 ,IFM.REGION_CODE + '/' +
	                  IFM.NATION_CODE + '/' +
	                  IFM.STATE_CODE + '/' +
	                  IFM.CITY_CODE + '/' +
	                  + CASE 
	                         WHEN IFM.FILE_TYPE = 1 THEN 'image'
	                         WHEN IFM.FILE_TYPE = 2 THEN 'movie'
	                         WHEN IFM.FILE_TYPE = 3 THEN 'document'
	                         ELSE 'image'
	                    END + '/' AS CONTENTS_PATH
	                  --,  	IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME AS [FILE_NAME]
	                 ,IFM.EXTENSION_NAME AS [FILE_EXTENSION_NAME]
	                 ,CASE 
	                       WHEN ISNULL(IFM.[FILE_NAME_S] ,'') = '' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME
	                       ELSE IFM.[FILE_NAME_S]
	                  END AS SMALL_IMG
	                 ,CASE 
	                       WHEN ISNULL(IFM.[FILE_NAME_M] ,'') = '' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME
	                       ELSE IFM.[FILE_NAME_M]
	                  END AS MIDDLE_IMG
	                 ,CASE 
	                       WHEN ISNULL(IFM.[FILE_NAME_L] ,'') = '' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME
	                       ELSE IFM.[FILE_NAME_L]
	                  END AS BIG_IMG
	                  --,	CASE
	                  --		WHEN PM.NEXT_DATE > DATEADD(DD,-1,GETDATE()) THEN CONVERT(VARCHAR(10),DATEADD(DD,-1,GETDATE()) ,111)
	                  --		ELSE CONVERT(VARCHAR(10),DATEADD(DD,-1,PM.NEXT_DATE) ,111)  END AS SEL_NEXT_DATE
	                  --,	CONVERT(VARCHAR(10), DATEADD(DD, PM.TOUR_DAY ,PM.LAST_DATE) ,111) AS SEL_LAST_DATE
	                 ,PM.NEXT_DATE
	                 ,PM.LAST_DATE
	                 ,PM.LOW_PRICE
	                 ,PM.HIGH_PRICE
	                 ,CASE 
	                       WHEN PM.SIGN_CODE = 'K' THEN '국내'
	                       ELSE '국외'
	                  END NATION_TYPE
	                 ,ISNULL(
	                      STUFF(
	                          (
	                              SELECT (',' + ATT_TYPE_NAME) AS [text()]
	                              FROM   (
	                                         SELECT DISTINCT
	                                                CASE 
	                                                     WHEN SUBSTRING(A.MASTER_CODE ,3 ,1) = 'G' THEN '골프'
	                                                     WHEN SUBSTRING(A.MASTER_CODE ,3 ,1) = 'W' THEN '허니문'
	                                                     WHEN SUBSTRING(A.MASTER_CODE ,3 ,1) = 'F' THEN '배낭여행'
	                                                     WHEN SUBSTRING(A.MASTER_CODE ,3 ,1) = 'H' THEN '배낭여행'
	                                                     WHEN SUBSTRING(A.MASTER_CODE ,3 ,1) = 'B' THEN '지방출발'
	                                                     WHEN B.BRANCH_CODE = 1 THEN '지방출발'
	                                                     WHEN B.BRAND_TYPE IS NOT NULL THEN '프리미엄'
	                                                     WHEN A.ATT_CODE IN ('P' ,'X' ,'Y') THEN '패키지'
	                                                     WHEN A.ATT_CODE IN ('B' ,'D' ,'E' ,'H' ,'I' ,'K' ,'R' ,'T' ,'Z') THEN '배낭여행'
	                                                     WHEN A.ATT_CODE IN ('W') THEN '허니문'
	                                                     WHEN A.ATT_CODE IN ('J') THEN '가족여행'
	                                                     WHEN A.ATT_CODE IN ('C') THEN '크루즈'
	                                                     WHEN A.ATT_CODE IN ('Y') THEN '성지순례'
	                                                     WHEN A.ATT_CODE IN ('K') THEN '트래킹'
	                                                     WHEN A.ATT_CODE IN ('D') THEN '데이투어'
	                                                     WHEN A.ATT_CODE IN ('S') THEN '레포츠'
	                                                     ELSE '패키지'
	                                                END AS ATT_TYPE_NAME
	                                         FROM   PKG_ATTRIBUTE A
	                                                INNER JOIN PKG_MASTER B
	                                                     ON  A.MASTER_CODE = B.MASTER_CODE
	                                         WHERE  A.MASTER_CODE = PM.MASTER_CODE
	                                     ) T 
	                                     FOR XML PATH('')
	                          )
	                         ,1
	                         ,1
	                         ,''
	                      )
	                     ,'패키지'
	                  ) AS ATT_TYPE_NAME
	                 ,CONVERT(
	                      VARCHAR
	                     ,ISNULL(
	                          (
	                              SELECT TOP 1 
	                                     CASE 
	                                          WHEN TOUR_NIGHT = 0 THEN '당일'
	                                          WHEN TOUR_NIGHT >= 12 THEN '12박 이상'
	                                          ELSE CONVERT(VARCHAR ,TOUR_NIGHT) + '박'
	                                     END
	                              FROM   PKG_DETAIL PD WITH(NOLOCK)
	                              WHERE  PD.MASTER_CODE = PM.MASTER_CODE
	                                     AND SHOW_YN = 'Y'
	                              ORDER BY
	                                     DEP_DATE DESC
	                          )
	                         ,''
	                      )
	                  ) AS TOUR_NIGHT
	                 ,CONVERT(
	                      VARCHAR
	                     ,ISNULL(
	                          (
	                              SELECT TOP 1 
	                                     CASE 
	                                          WHEN TOUR_DAY >= 13 THEN '13일 이상'
	                                          ELSE CONVERT(VARCHAR ,TOUR_DAY) + '일'
	                                     END AS TOUR_DAY
	                              FROM   PKG_DETAIL PD WITH(NOLOCK)
	                              WHERE  PD.MASTER_CODE = PM.MASTER_CODE
	                                     AND SHOW_YN = 'Y'
	                              ORDER BY
	                                     DEP_DATE DESC
	                          )
	                         ,''
	                      )
	                  ) AS TOUR_DAY
	                 ,ISNULL(
	                      (
	                          SELECT CASE 
	                                      WHEN PC.NATION_CODE = 'KR' THEN 'KR / 한국'
	                                      ELSE (
	                                               SELECT TOP 1 EST_NATION_NAME
	                                               FROM   EST_NATION_ATTR_MAP ENA WITH(NOLOCK)
	                                               WHERE  ENA.NATION_CODE = PC.NATION_CODE
	                                           )
	                                 END
	                          FROM   PUB_AIRPORT PA WITH(NOLOCK)
	                                 LEFT OUTER JOIN PUB_CITY PC WITH(NOLOCK)
	                                      ON  PA.CITY_CODE = PC.CITY_CODE
	                          WHERE  PA.AIRPORT_CODE = (
	                                     SELECT TOP 1 
	                                            PTS.DEP_DEP_AIRPORT_CODE
	                                     FROM   PKG_DETAIL PD WITH(NOLOCK)
	                                            INNER JOIN PRO_TRANS_SEAT PTS WITH(NOLOCK)
	                                                 ON  PD.SEAT_CODE = PTS.SEAT_CODE
	                                     WHERE  PD.MASTER_CODE = PM.MASTER_CODE
	                                            AND PD.SHOW_YN = 'Y'
	                                     ORDER BY
	                                            PD.DEP_DATE DESC
	                                 )
	                      )
	                     ,CASE 
	                           WHEN PM.SIGN_CODE = 'K' THEN 'KR / 한국'
	                           ELSE '기타국가'
	                      END
	                  ) AS DEP_NATION
	                 ,ISNULL(
	                      (
	                          SELECT CASE PA.CITY_CODE
	                                      WHEN 'ICN' THEN 'SEL  (인천)'
	                                      WHEN 'GMP' THEN 'SEL  (김포)'
	                                      WHEN 'CJU' THEN 'CJU  (제주)'
	                                      WHEN 'PUS' THEN 'PUS  (부산)'
	                                      WHEN 'TAE' THEN 'TAE  (대구)'
	                                      WHEN 'CJJ' THEN 'CJJ  (청주)'
	                                      WHEN 'YNY' THEN 'YNY  (양양)'
	                                      WHEN 'MWX' THEN 'MWX  (무안)'
	                                      WHEN 'SEL' THEN 'SEL  (서울)'
	                                      WHEN 'KWJ' THEN 'KWJ  (광주)'
	                                      WHEN 'WJU' THEN 'WJU  (원주)'
	                                      WHEN 'RSU' THEN 'RSU  (여수)'
	                                      WHEN 'KPO' THEN 'KPO  (포항)'
	                                      WHEN 'KUV' THEN 'KUV  (군산)'
	                                      ELSE (
	                                               SELECT TOP 1 EST_CITY_NAME
	                                               FROM   EST_CITY_ATTR_MAP ENA WITH(NOLOCK)
	                                               WHERE  ENA.CITY_CODE = PA.CITY_CODE
	                                           )
	                                 END
	                          FROM   PUB_AIRPORT PA WITH(NOLOCK)
	                          WHERE  PA.AIRPORT_CODE = (
	                                     SELECT TOP 1 
	                                            PTS.DEP_DEP_AIRPORT_CODE
	                                     FROM   PKG_DETAIL PD WITH(NOLOCK)
	                                            INNER JOIN PRO_TRANS_SEAT PTS WITH(NOLOCK)
	                                                 ON  PD.SEAT_CODE = PTS.SEAT_CODE
	                                     WHERE  PD.MASTER_CODE = PM.MASTER_CODE
	                                            AND PD.SHOW_YN = 'Y'
	                                     ORDER BY
	                                            PD.DEP_DATE DESC
	                                 )
	                      )
	                     ,'기타지역'
	                  ) AS DEP_CITY
	                 ,ISNULL(
	                      (
	                          SELECT CASE 
	                                      WHEN PC.NATION_CODE = 'KR' THEN 'KR / 한국'
	                                      ELSE (
	                                               SELECT TOP 1 EST_NATION_NAME
	                                               FROM   EST_NATION_ATTR_MAP ENA WITH(NOLOCK)
	                                               WHERE  ENA.NATION_CODE = PC.NATION_CODE
	                                           )
	                                 END
	                          FROM   PUB_AIRPORT PA WITH(NOLOCK)
	                                 LEFT OUTER JOIN PUB_CITY PC WITH(NOLOCK)
	                                      ON  PA.CITY_CODE = PC.CITY_CODE
	                          WHERE  PA.AIRPORT_CODE = (
	                                     SELECT TOP 1 
	                                            PTS.ARR_DEP_AIRPORT_CODE
	                                     FROM   PKG_DETAIL PD WITH(NOLOCK)
	                                            INNER JOIN PRO_TRANS_SEAT PTS WITH(NOLOCK)
	                                                 ON  PD.SEAT_CODE = PTS.SEAT_CODE
	                                     WHERE  PD.MASTER_CODE = PM.MASTER_CODE
	                                            AND PD.SHOW_YN = 'Y'
	                                     ORDER BY
	                                            PD.DEP_DATE DESC
	                                 )
	                      )
	                     ,CASE 
	                           WHEN PM.SIGN_CODE = 'K' THEN 'KR / 한국'
	                           ELSE '기타국가'
	                      END
	                  ) AS ARR_NATION
	                 ,ISNULL(
	                      (
	                          SELECT CASE PA.CITY_CODE
	                                      WHEN 'ICN' THEN 'SEL  (인천)'
	                                      WHEN 'GMP' THEN 'SEL  (김포)'
	                                      WHEN 'CJU' THEN 'CJU  (제주)'
	                                      WHEN 'PUS' THEN 'PUS  (부산)'
	                                      WHEN 'TAE' THEN 'TAE  (대구)'
	                                      WHEN 'CJJ' THEN 'CJJ  (청주)'
	                                      WHEN 'YNY' THEN 'YNY  (양양)'
	                                      WHEN 'MWX' THEN 'MWX  (무안)'
	                                      WHEN 'SEL' THEN 'SEL  (서울)'
	                                      WHEN 'KWJ' THEN 'KWJ  (광주)'
	                                      WHEN 'WJU' THEN 'WJU  (원주)'
	                                      WHEN 'RSU' THEN 'RSU  (여수)'
	                                      WHEN 'KPO' THEN 'KPO  (포항)'
	                                      WHEN 'KUV' THEN 'KUV  (군산)'
	                                      ELSE (
	                                               SELECT TOP 1 EST_CITY_NAME
	                                               FROM   EST_CITY_ATTR_MAP ENA WITH(NOLOCK)
	                                               WHERE  ENA.CITY_CODE = PA.CITY_CODE
	                                           )
	                                 END
	                          FROM   PUB_AIRPORT PA WITH(NOLOCK)
	                          WHERE  PA.AIRPORT_CODE = (
	                                     SELECT TOP 1 
	                                            PTS.ARR_DEP_AIRPORT_CODE
	                                     FROM   PKG_DETAIL PD WITH(NOLOCK)
	                                            INNER JOIN PRO_TRANS_SEAT PTS WITH(NOLOCK)
	                                                 ON  PD.SEAT_CODE = PTS.SEAT_CODE
	                                     WHERE  PD.MASTER_CODE = PM.MASTER_CODE
	                                            AND PD.SHOW_YN = 'Y'
	                                     ORDER BY
	                                            PD.DEP_DATE DESC
	                                 )
	                      )
	                     ,'기타지역'
	                  ) AS ARR_CITY
	           FROM   PKG_MASTER PM WITH(NOLOCK)
	                  INNER JOIN PKG_MASTER_AFFILIATE PMA WITH(NOLOCK)
	                       ON  PM.MASTER_CODE = PMA.MASTER_CODE
	                           AND PMA.PROVIDER = @PROVIDER_EST
	                           AND PMA.USE_YN = 'Y'
	                  INNER JOIN PKG_FILE_MANAGER AS PFM WITH(NOLOCK)
	                       ON  PM.MASTER_CODE = PFM.MASTER_CODE
	                           AND PFM.FILE_CODE = (
	                                   SELECT TOP 1 
	                                          S1.FILE_CODE
	                                   FROM   PKG_FILE_MANAGER AS S1 WITH(NOLOCK)
	                                          INNER JOIN INF_FILE_MASTER AS S2 WITH(NOLOCK)
	                                               ON  S1.FILE_CODE = S2.FILE_CODE
	                                   WHERE  S1.MASTER_CODE = PFM.MASTER_CODE
	                                          AND S2.SHOW_YN = 'Y'
	                                   ORDER BY
	                                          SHOW_ORDER
	                               )
	                  INNER JOIN INF_FILE_MASTER AS IFM WITH(NOLOCK)
	                       ON  PFM.FILE_CODE = IFM.FILE_CODE 
	                           --WHERE PM.LAST_DATE > GETDATE()
	           WHERE  PM.LAST_DATE > DATEADD(D ,2 ,GETDATE())
	                  AND ((@MASTER_CODE = '') OR (PM.MASTER_CODE = @MASTER_CODE))
	                  AND PM.SHOW_YN = 'Y'
	                      --AND PM.MASTER_CODE IN ('JPP628', 'JPP613', 'JPC614', 'IPP603', 'EPP439', 'EPP4310', 'CPP861', 'CPP345', 'CPP344', 'APP128', 'APP127', 'APP0506')
	       ) A
	       LEFT JOIN PKG_MASTER_AFFILIATE B
	            ON  A.MASTER_CODE = B.MASTER_CODE
	                AND B.PROVIDER = @PROVIDER_EST
	                AND USE_YN = 'Y'
	       LEFT JOIN EST_PRO_CATEGORY_V2 C
	            ON  B.AFF_CATE_CODE = C.EST_CATE_SCODE;
	
	WITH MASTER_LIST AS
	(
	    SELECT UPPER(A.MASTER_CODE) AS MASTER_CODE
	    FROM   PKG_MASTER A WITH(NOLOCK)
	           INNER JOIN PKG_MASTER_AFFILIATE B WITH(NOLOCK)
	                ON  A.MASTER_CODE = B.MASTER_CODE
	                    AND USE_YN = 'Y'
	    WHERE  B.PROVIDER = @PROVIDER_EST
	           AND ((@MASTER_CODE = '') OR (A.MASTER_CODE = @MASTER_CODE))
	           AND A.SHOW_YN = 'Y'
	               --AND A.MASTER_CODE IN ('JPP628', 'JPP613', 'JPC614', 'IPP603', 'EPP439', 'EPP4310', 'CPP861', 'CPP345', 'CPP344', 'APP128', 'APP127', 'APP0506')
	) 
	
	SELECT *
	FROM   (
	           SELECT A.PRO_CODE + '|' + CONVERT(VARCHAR ,D.PRICE_SEQ) AS itemNo
	                 ,A.PRO_NAME AS itemNm
	                 ,(CONVERT(VARCHAR(10) ,B.DEP_DEP_DATE ,111)) AS departBgnDy
	                 ,REPLACE(B.DEP_DEP_TIME ,':' ,'') AS departBgnTime
	                 ,(B.DEP_TRANS_CODE + B.DEP_TRANS_NUMBER) AS departAirNo
	                 ,ISNULL(
	                      (
	                          SELECT EST_AIRLINE_NAME
	                          FROM   EST_AIRLINE_ATTR_MAP EAAM WITH(NOLOCK)
	                          WHERE  EAAM.AIRLINE_CODE = B.DEP_TRANS_CODE
	                      )
	                     ,'기타'
	                  ) AS departAirlineCd
	                 ,(CONVERT(VARCHAR(10) ,B.ARR_ARR_DATE ,111)) AS arrivalEndDy
	                 ,REPLACE(B.ARR_ARR_TIME ,':' ,'') AS arrivalEndTime
	                 ,(B.ARR_TRANS_CODE + B.ARR_TRANS_NUMBER) AS arrivalAirNo
	                 ,ISNULL(
	                      (
	                          SELECT EST_AIRLINE_NAME
	                          FROM   EST_AIRLINE_ATTR_MAP EAAM WITH(NOLOCK)
	                          WHERE  EAAM.AIRLINE_CODE = B.ARR_TRANS_CODE
	                      )
	                     ,'기타'
	                  ) AS arrivalAirlineCd
	                 ,CASE 
	                       WHEN A.TOUR_NIGHT = 0 THEN '당일'
	                       WHEN A.TOUR_NIGHT >= 12 THEN '12박 이상'
	                       ELSE CONVERT(VARCHAR ,A.TOUR_NIGHT) + '박'
	                  END AS itemTourNightDays
	                 ,CASE 
	                       WHEN A.TOUR_DAY >= 13 THEN '13일 이상'
	                       ELSE CONVERT(VARCHAR ,A.TOUR_DAY) + '일'
	                  END AS itemTourDays
	                 ,CASE 
	                       WHEN A.RES_ADD_YN = 'Y'
	           AND A.MAX_COUNT = -1 THEN '02' -- 대기예약
	               WHEN A.RES_ADD_YN = 'Y'
	           AND (A.MAX_COUNT = 0 OR (A.MAX_COUNT - DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) > 0)) THEN '01' -- 예약가능
	               ELSE '03' -- 예약마감
	               END AS rsvStatCd
	          ,ISNULL(dbo.XN_PRO_DETAIL_SALE_PRICE_CUTTING(A.PRO_CODE ,D.PRICE_SEQ) ,'0') AS selPrc	-- 정상가
	          ,ISNULL(D.ADT_PRICE ,'0') AS adultSelPrc	-- 성인가
	          ,'02' AS adultTaxType	-- 성인 유류세 타입 (01 : %, 02 : 원)
	          ,RTRIM(ISNULL(dbo.FN_ARR_SPLIT(dbo.XN_PRO_DETAIL_QCHARGE_PRICE_ALL(A.PRO_CODE ,D.PRICE_SEQ) ,'|' ,1) ,'0')) AS adultTaxPrc	-- 성인 유류세 금액
	          ,'02' AS adultBillType	-- 성인 제세공과금 타입 (01 : %, 02 : 원)
	          ,'0' AS adultBillPrc	-- 성인 제세공과금 금액
	          ,ISNULL(D.CHD_PRICE ,'0') AS childSelPrc	-- 아동가
	          ,'02' AS childTaxType	-- 아동 유류세 타입 (01 : %, 02 : 원)
	          ,RTRIM(ISNULL(dbo.FN_ARR_SPLIT(dbo.XN_PRO_DETAIL_QCHARGE_PRICE_ALL(A.PRO_CODE ,D.PRICE_SEQ) ,'|' ,2) ,'0')) AS childTaxPrc	-- 아동 유류세 금액
	          ,'02' AS childBillType	-- 아동 제세공과금 타입 (01 : %, 02 : 원)
	          ,'0' AS childBillPrc	-- 아동 제세공과금 금액
	          ,ISNULL(D.INF_PRICE ,'0') AS babySelPrc	-- 유아가
	          ,'02' AS babyTaxType	-- 유아 유류세 타입 (01 : %, 02 : 원)
	          ,RTRIM(ISNULL(dbo.FN_ARR_SPLIT(dbo.XN_PRO_DETAIL_QCHARGE_PRICE_ALL(A.PRO_CODE ,D.PRICE_SEQ) ,'|' ,3) ,'0')) AS babyTaxPrc	-- 유아 유류세 금액
	          ,'02' AS babyBillType	-- 유아 제세공과금 타입 (01 : %, 02 : 원)
	          ,'0' AS babyBillPrc	-- 유아 제세공과금 금액
--	          ,((CASE WHEN A.MAX_COUNT = 0 THEN 99 WHEN A.MAX_COUNT = -1 THEN 0 ELSE A.MAX_COUNT END) -((DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) + FAKE_COUNT))) AS remainQty	-- 총 확보좌석
	          ,((CASE WHEN A.MAX_COUNT = 0 THEN 30 WHEN A.MAX_COUNT < 0 THEN 0 ELSE A.MAX_COUNT END) -((DBO.FN_PRO_GET_RES_COUNT(A.PRO_CODE) + FAKE_COUNT))) AS remainQty	-- 총 확보좌석
	          ,ISNULL(A.MIN_COUNT ,'0') AS minSelQty	-- 출발최소인원
	          ,'/Product/Package/PackageDetail?ProCode=' + A.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR ,D.PRICE_SEQ) + '&IsProvider=Y&ProviderCode=11st' AS prdDetailUrl	-- 상품상세 url ( iframeDetailYn이 Y인 경우 필수 )
	          ,--'/Mobile/Product/PackageDetail?ProCode=' + A.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR, D.PRICE_SEQ) + '&ProviderCode=11st' AS prdDetailUrlMobile, -- 모바일 상품상세 url ( iframeDetailYn이 Y인 경우 필수 )
	           '/Mobile/Affiliate/EstPackageInfo?ProCode=' + A.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR ,D.PRICE_SEQ) AS prdDetailUrlMobile	-- 변경
	          ,'' AS itemPromotionFlag	-- 상품프로모션 플래그
	          ,'/Content/Info/IndividualInfo/StandardTerm.html' AS tourBasicAgreement	-- 여행약관
	          ,CASE 
	                WHEN ISNULL(A.PKG_CONTRACT ,'') = '' THEN ''
	                ELSE '/Support/TravelRule?ProCode=' + A.PRO_CODE
	           END AS tourAddAgreement	-- 추가약관
	          ,'/Mobile/Affiliate/EstPackageInfo?ProCode=' + A.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR ,D.PRICE_SEQ) + '&Type=REVIEW' AS spclBnftInfoUrl	-- 모바일 특성안내
	          ,'/Mobile/Affiliate/EstPackageInfo?ProCode=' + A.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR ,D.PRICE_SEQ) + '&Type=REMARK' AS cautUrl	-- 모바일 유의사항
	          ,(
	               SELECT COUNT(SHOP_SEQ)
	               FROM   PKG_DETAIL_SHOPPING
	               WHERE  PRO_CODE = A.PRO_CODE
	           ) AS shoppingCount -- 쇼핑 횟수
	          ,A.PKG_REVIEW AS prdDetailInfo --상품상세(리뷰?)
	          ,(
	               SELECT SUM(DINNER_CNT1 + DINNER_CNT2 + DINNER_CNT3) AS DINNER_CNT
	               FROM   (
	                          SELECT CASE 
	                                      WHEN ISNULL(DINNER_1 ,'불포함') = '불포함' THEN 0
	                                      ELSE 1
	                                 END AS DINNER_CNT1
	                                ,CASE 
	                                      WHEN ISNULL(DINNER_2 ,'불포함') = '불포함' THEN 0
	                                      ELSE 1
	                                 END AS DINNER_CNT2
	                                ,CASE 
	                                      WHEN ISNULL(DINNER_3 ,'불포함') = '불포함' THEN 0
	                                      ELSE 1
	                                 END AS DINNER_CNT3
	                          FROM   PKG_DETAIL_PRICE_HOTEL
	                          WHERE  PRO_CODE = A.PRO_CODE
	                      )DINNER
	           )AS mealCount --식사횟수
	          ,(
	               SELECT CASE 
	                           WHEN (SUM(ADT_COST + CHD_COST + INF_COST)) > 0 THEN 'Y'
	                           ELSE 'N'
	                      END AS TIP_YN
	               FROM   PKG_DETAIL_PRICE_GROUP_COST
	               WHERE  PRO_CODE = A.PRO_CODE
	           ) 
	           AS guideFeeYn --팁여부
	           FROM MASTER_LIST Z
	           INNER JOIN PKG_DETAIL A WITH(NOLOCK) ON Z.MASTER_CODE = A.MASTER_CODE
	           AND A.SHOW_YN = 'Y'
	               INNER JOIN PRO_TRANS_SEAT B WITH(NOLOCK) ON A.SEAT_CODE = B.SEAT_CODE
	               INNER JOIN PKG_DETAIL_PRICE D WITH(NOLOCK) ON A.PRO_CODE = D.PRO_CODE
	               --WHERE A.DEP_DATE > GETDATE();
	               WHERE A.DEP_DATE > GETDATE()
	           AND A.DEP_DATE < DATEADD(MONTH ,12 ,GETDATE())
	       ) T
	WHERE  remainQty > 0 -- 좌석있고
	       AND rsvStatCd = '01' -- 예약가능만
	ORDER BY
	       ITEMNO ASC
END
GO
