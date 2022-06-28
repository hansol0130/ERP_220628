USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SELECT_PRODUCT_EST_v2
■ DESCRIPTION				: 11번가 상품연동
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_PKG_MASTER_SELECT_PRODUCT_EST_v2 'APP0527'
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
2022-02-14			김성호			11번가 리뉴얼을 위한 데이터 변경작업 (큰 변경)
2022-03-25			오정민			12박, 13일이 넘어가면 ..이상으로 보정하는 로직 제거
2022-04-28          이장훈          rsvStatCd - (01 ,02,03) 에서 예약가능(10) , 출발가능(20),  대기예약(30) ,마감예약(40) 변경 
2022-05-09          이장훈          guideFeeYn 팁여부 ADT_COST(성인비용)+CHD_COST(아동비용)+INF_COST(유아비용)  > 0  ? 'N' : 'Y' 으로 변경
2022-05-25          이장훈          상품 포함 / 불포함 내용추가 (PKG_DETAIL_PRICE JOIN 추가) / #TMP_PRO_LIST 에 제휴사에 등록된 상품만 조회 추가 
2022-06-02			이장훈			qty 필드 신규 추가 / remainQty (총 확보좌석) = 30 또는 최대 인원수(MAX_COUNT) , qty (잔여좌석수량) =  총좌석수 - 예약자좌석수 - 가짜 예약자수  수정
									qty > 0 잔여좌석수량 존재시 상품 xml 생성
=======================================================================================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_EST_v2]	
	@MASTER_CODE VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @PROVIDER_EST INT = 31;
	
	---------------------------------------------------------------
	-- 대상 테이블 생성
	---------------------------------------------------------------	
	IF (OBJECT_ID('tempdb..#TMP_PRO_LIST') IS NOT NULL)
	BEGIN
	    DROP TABLE #TMP_PRO_LIST;
	END
	
	CREATE TABLE #TMP_PRO_LIST
	(
		PRO_CODE              VARCHAR(20) NOT NULL
	   ,MASTER_CODE           VARCHAR(10) NOT NULL
	   ,AFF_CATE_CODE         VARCHAR(20)
	   ,ROW_NUM               INT
	   ,shoppingCount         INT
	   ,mealCount             INT
	   ,guideFeeYn            VARCHAR(1)
	   ,RES_COUNT             INT
	   ,departBgnDy           VARCHAR(10)
	   ,departBgnTime         VARCHAR(5)
	   ,departAirNo           VARCHAR(10)
	   ,departAirlineCd       VARCHAR(100)
	   ,arrivalEndDy          VARCHAR(10)
	   ,arrivalEndTime        VARCHAR(5)
	   ,arrivalAirNo          VARCHAR(10)
	   ,arrivalAirlineCd      VARCHAR(100)
	   ,departEndDy           VARCHAR(10)
	   ,departEndTime         VARCHAR(5)
	   ,arrivalBgnDy          VARCHAR(10)
	   ,arrivalBgnTime        VARCHAR(5)
	   ,DEP_FLYING_SEC        INT
	   ,ARR_FLYING_SEC        INT
	   ,departTotalTime       VARCHAR(20)
	   ,arrivalTotalTime      VARCHAR(20)
	   ,SeatClass             VARCHAR(20)
	   ,DEP_TRANSIT_COUNT     INT
	   ,ARR_TRANSIT_COUNT     INT
	);
	CREATE NONCLUSTERED INDEX #IDX_TMP_PRO_LIST ON #TMP_PRO_LIST(PRO_CODE);
	CREATE NONCLUSTERED INDEX #IDX_TMP_PRO_LIST_2 ON #TMP_PRO_LIST(MASTER_CODE ,ROW_NUM);
	
	---------------------------------------------------------------
	-- 대상 행사 선정
	---------------------------------------------------------------
	INSERT INTO #TMP_PRO_LIST
	  (
	    PRO_CODE
	   ,MASTER_CODE
	   ,AFF_CATE_CODE
	   ,ROW_NUM
	  )
	SELECT PD.PRO_CODE
	      ,PD.MASTER_CODE
	      ,PMA.AFF_CATE_CODE
	      ,ROW_NUMBER() OVER(PARTITION BY PD.MASTER_CODE ORDER BY PD.DEP_DATE DESC)
	FROM   dbo.PKG_MASTER_AFFILIATE PMA WITH(NOLOCK)
	       INNER JOIN dbo.PKG_MASTER PM WITH(NOLOCK)
	            ON  PMA.MASTER_CODE = PM.MASTER_CODE
	       INNER JOIN dbo.PKG_DETAIL PD WITH(NOLOCK)
	            ON  PM.MASTER_CODE = PD.MASTER_CODE
	WHERE  PMA.PROVIDER = @PROVIDER_EST
	       AND PMA.USE_YN = 'Y'
	       AND (CASE WHEN @MASTER_CODE = '' THEN 1 WHEN PMA.MASTER_CODE = @MASTER_CODE THEN 1 ELSE 0 END) = 1
	       AND PM.SHOW_YN = 'Y'
	       AND PD.DEP_DATE > DATEADD(D ,2 ,GETDATE())
	       AND PD.DEP_DATE < DATEADD(MONTH ,12 ,GETDATE())
	       AND PD.SHOW_YN = 'Y'
	       AND PMA.AFF_CATE_CODE IS NOT NULL;
	
	---------------------------------------------------------------
	-- 마스터 정보
	---------------------------------------------------------------
	SELECT '' AS selMnbdNckNm
	      ,ATLIST.AFF_CATE_CODE AS dispCtgrNo
	      ,RTRIM(ATLIST.MASTER_NAME) AS prdNm
	      ,ATLIST.MASTER_CODE AS sellerPrdCd
	      ,'01' AS suplDtyfrPrdClfCd -- 부가세/면세상품코드 01:과세상품| 02:면세상품 | 03:영세상품
	      ,ATLIST.CONTENTS_PATH + COALESCE(CASE WHEN FILE_EXTENSION_NAME = 'BMP' THEN ATLIST.SMALL_IMG ELSE ATLIST.MIDDLE_IMG END ,ATLIST.BIG_IMG ,ATLIST.SMALL_IMG) AS prdImage01
	      ,''  AS prdImage02
	      ,''  AS prdImage03
	      ,''  AS prdImage04
	      ,''  AS htmlDetail
	      ,'N' AS selTermUseYn -- 판매기간 설정
	      ,''  AS selPrdClfCd -- # 판매기간코드(판매기간 'Y' 경우 필수)
	      ,''  AS aplBgnDy -- # 판매 시작일(판매기간 'Y' 경우 필수)
	      ,''  AS aplEndDy -- # 판매 종료일(판매기간 'Y' 경우 필수)
	      ,ATLIST.LOW_PRICE AS selPrc
	      ,ATLIST.HIGH_PRICE AS selMaxPrc
	      ,'N' AS cuponcheck -- 기본즉시할인 설정여부(Y:설정 | N:설정안함 | S:기본값유지(상품수정)
	      ,''  AS dscAmtPercnt -- # 기본즉시할인 설정시 설정
	      ,''  AS cupnDscMthdCd -- # 기본즉시할인 설정시 설정
	      ,''  AS cupnUseLmtDyYn -- # 기본즉시할인 설정시 설정
	      ,''  AS cupnIssEndDy -- # 기본즉시할인 설정시 설정
	                          --,'N' AS pointYN	-- 포인트 지급설정
	                          --,'' AS pointValue	-- # 포인트 지급설정시 설정
	                          --,'' AS spplWyCd	-- # 포인트 지급설정시 설정
	      ,'N' AS ocbYN -- OK캐시백 지급 설정
	      ,''  AS ocbValue -- #OK캐시백 지급설정시 설정
	      ,''  AS ocbWyCd -- #OK캐시백 지급설정시 설정
	                     --,'N' AS mileageYN	-- 마일리지 지급설정
	                     --,'' AS mileageValue	-- # 마일리지 지금설정시 설정
	                     --,'' AS mileageWyCd	-- # 마일리지 지금설정시 설정
	      ,'N' AS intFreeYN -- 무이자 할수 제공 설정
	      ,''  AS intfreeMonClfCd -- # 무이자 할수 제공 설정시 설정
	      ,'N' AS hopeShpYn -- 희망후원 설정
	      ,''  AS hopeShpPnt -- # 희망후원 설정시 설정
	      ,''  AS hopeShpWyCd -- # 희망후원 설정시 설정
	      ,'N' AS prcCompExpYn -- 가격비교사이트 설정
	      ,''  AS avrtStmt -- 추후에 상품명에서 대괄호 안에있는 문구 뽑아서 할 예정
	      ,'I' AS dtlsDescTyp -- I : 아이프레임 / H : HTML
	      ,'29' AS prdTypCd -- 상품 구분코드( 여행내재화상품 29 고정)
	      ,CONVERT(VARCHAR(10) ,ATLIST.NEXT_DATE ,111) AS prdSvcBgnDy -- 최초 출발일
	      ,CONVERT(VARCHAR(10) ,ATLIST.LAST_DATE ,111) AS prdSvcEndDy -- 마지막 출발일
	      ,'Y' AS drcStlYn -- 즉시결제여부
	      ,'Y' AS htmlDetailIframeYn -- iframe으로 호출하는지의 여부
	      ,'00' AS svcAreaCd
	      ,'N'  AS penaltyApplyYn
	      ,'N'  AS directStlYn
	      ,''   AS promotionFlag
	      ,ATLIST.ATT_TYPE_NAME AS tourPrdType
	      ,ATLIST.NATION_TYPE AS tourNationType
	      ,ATLIST.TOUR_NIGHT AS tourNightDays
	      ,ATLIST.TOUR_DAY AS tourDays
	      ,ATLIST.DEP_NATION AS departCountry
	      ,ATLIST.DEP_CITY AS departCity
	      ,ATLIST.ARR_NATION AS arrivalCountry
	      ,ATLIST.ARR_CITY AS arrivalCity
	      ,'' AS passStops -- 여행지 정보 (선택)
	FROM   (
	           SELECT TPL.MASTER_CODE
	                 ,PM.MASTER_NAME
	                 ,TPL.AFF_CATE_CODE
	                 ,(IFM.REGION_CODE + '/' + IFM.NATION_CODE + '/' + IFM.STATE_CODE + '/' + IFM.CITY_CODE + '/' + + CASE WHEN IFM.FILE_TYPE = 1 THEN 'image' WHEN IFM.FILE_TYPE = 2 THEN 'movie' WHEN IFM.FILE_TYPE = 3 THEN 'document' ELSE 'image' END + '/')  AS CONTENTS_PATH
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
	                 ,PM.NEXT_DATE
	                 ,PM.LAST_DATE
	                 ,PM.LOW_PRICE
	                 ,PM.HIGH_PRICE
	                 ,CASE 
	                       WHEN PM.SIGN_CODE = 'K' THEN '국내'
	                       ELSE '국외'
	                  END NATION_TYPE
	                 ,ATL.ATT_TYPE_NAME
					 ,(CASE WHEN PD.TOUR_NIGHT = 0 THEN '당일' ELSE CONVERT(VARCHAR ,PD.TOUR_NIGHT) + '박' END) TOUR_NIGHT
	                 ,(CONVERT(VARCHAR ,PD.TOUR_DAY) + '일') TOUR_DAY
	                 ,ISNULL(
	                      (
	                          CASE 
	                               WHEN DPC.NATION_CODE = 'KR' THEN 'KR / 한국'
	                               ELSE (
	                                        SELECT TOP 1 EST_NATION_NAME
	                                        FROM   EST_NATION_ATTR_MAP ENA WITH(NOLOCK)
	                                        WHERE  ENA.NATION_CODE = DPC.NATION_CODE
	                                    )
	                          END
	                      )
	                     ,CASE 
	                           WHEN PM.SIGN_CODE = 'K' THEN 'KR / 한국'
	                           ELSE '기타국가'
	                      END
	                  ) DEP_NATION
	                 ,ISNULL(
	                      (
	                          CASE DPA.CITY_CODE
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
	                                        WHERE  ENA.CITY_CODE = DPA.CITY_CODE
	                                    )
	                          END
	                      )
	                     ,'기타지역'
	                  ) DEP_CITY
	                 ,ISNULL(
	                      (
	                          CASE 
	                               WHEN APC.NATION_CODE = 'KR' THEN 'KR / 한국'
	                               ELSE (
	                                        SELECT TOP 1 EST_NATION_NAME
	                                        FROM   EST_NATION_ATTR_MAP ENA WITH(NOLOCK)
	                                        WHERE  ENA.NATION_CODE = APC.NATION_CODE
	                                    )
	                          END
	                      )
	                     ,CASE 
	                           WHEN PM.SIGN_CODE = 'K' THEN 'KR / 한국'
	                           ELSE '기타국가'
	                      END
	                  ) ARR_NATION
	                 ,ISNULL(
	                      (
	                          CASE APA.CITY_CODE
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
	                                        WHERE  ENA.CITY_CODE = APA.CITY_CODE
	                                    )
	                          END
	                      )
	                     ,'기타지역'
	                  ) ARR_CITY
	           FROM   #TMP_PRO_LIST TPL
	                  INNER JOIN dbo.PKG_DETAIL PD
	                       ON  TPL.PRO_CODE = PD.PRO_CODE
	                  INNER JOIN dbo.PKG_MASTER PM
	                       ON  PD.MASTER_CODE = PM.MASTER_CODE
	                  LEFT JOIN dbo.INF_FILE_MASTER IFM
	                       ON  PM.MAIN_FILE_CODE = IFM.FILE_CODE
	                  LEFT JOIN dbo.PRO_TRANS_SEAT PTS
	                       ON  PTS.SEAT_CODE = PD.SEAT_CODE
	                  LEFT JOIN PUB_AIRPORT DPA
	                       ON  DPA.AIRPORT_CODE = PTS.DEP_DEP_AIRPORT_CODE
	                  LEFT JOIN PUB_CITY DPC
	                       ON  DPC.CITY_CODE = DPA.CITY_CODE
	                  LEFT JOIN PUB_AIRPORT APA
	                       ON  APA.AIRPORT_CODE = PTS.ARR_DEP_AIRPORT_CODE
	                  LEFT JOIN PUB_CITY APC
	                       ON  APC.CITY_CODE = APA.CITY_CODE
	                  CROSS APPLY (
						   SELECT ISNULL(
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
										  ),1,1,'')
						 ,'패키지') ATT_TYPE_NAME
				  ) ATL
	           WHERE  TPL.ROW_NUM = 1
	       ) ATLIST
	       LEFT JOIN EST_PRO_CATEGORY_V2 EPC2
	            ON  ATLIST.AFF_CATE_CODE = EPC2.EST_CATE_SCODE
	ORDER BY
	       ATLIST.MASTER_CODE;
	
	---------------------------------------------------------------
	-- 쇼핑횟수
	---------------------------------------------------------------
	UPDATE TPL
	SET    TPL.shoppingCount = PDS_LIST.SHOP_SEQ
	FROM   #TMP_PRO_LIST TPL
	       INNER JOIN (
	                SELECT PDS.PRO_CODE
	                      ,COUNT(1) SHOP_SEQ
	                FROM   dbo.PKG_DETAIL_SHOPPING PDS WITH(NOLOCK)
	                WHERE  PDS.PRO_CODE IN (SELECT PRO_CODE
	                                        FROM   #TMP_PRO_LIST)
	                GROUP BY
	                       PDS.PRO_CODE
	            ) PDS_LIST
	            ON  TPL.PRO_CODE = PDS_LIST.PRO_CODE
	WHERE  1 = 1
	
	---------------------------------------------------------------
	-- 식사횟수
	---------------------------------------------------------------
	UPDATE TPL
	SET    TPL.mealCount = (PDS_LIST.DINNER_CNT1 + PDS_LIST.DINNER_CNT2 + PDS_LIST.DINNER_CNT3)
	FROM   #TMP_PRO_LIST TPL
	       INNER JOIN (
	                SELECT PDPH.PRO_CODE
	                      ,SUM(CASE WHEN ISNULL(DINNER_1 ,'불포함') = '불포함' THEN 0 ELSE 1 END) AS DINNER_CNT1
	                      ,SUM(CASE WHEN ISNULL(DINNER_2 ,'불포함') = '불포함' THEN 0 ELSE 1 END) AS DINNER_CNT2
	                      ,SUM(CASE WHEN ISNULL(DINNER_3 ,'불포함') = '불포함' THEN 0 ELSE 1 END) AS DINNER_CNT3
	                FROM   dbo.PKG_DETAIL_PRICE_HOTEL PDPH WITH(NOLOCK)
	                WHERE  PDPH.PRO_CODE IN (SELECT PRO_CODE
	                                         FROM   #TMP_PRO_LIST)
	                GROUP BY
	                       PDPH.PRO_CODE
	            ) PDS_LIST
	            ON  TPL.PRO_CODE = PDS_LIST.PRO_CODE
	WHERE  1 = 1
	
	---------------------------------------------------------------
	-- 팁여부
	---------------------------------------------------------------
	UPDATE TPL
	SET    TPL.guideFeeYn = ISNULL(PDPG_LIST.TIP_YN ,'N')
	FROM   #TMP_PRO_LIST TPL
	       LEFT JOIN (
	                SELECT PDPG.PRO_CODE
					       , CASE WHEN  ISNULL(PDPG.ADT_COST , 0) + ISNULL(PDPG.CHD_COST,0) + ISNULL(PDPG.INF_COST , 0)  > 0 THEN 'N' ELSE 'Y' END AS TIP_YN
	                      --,MAX('Y') TIP_YN
	                FROM   dbo.PKG_DETAIL_PRICE_GROUP_COST PDPG WITH(NOLOCK)
	                WHERE  PDPG.PRO_CODE IN (SELECT PRO_CODE
	                                         FROM   #TMP_PRO_LIST)
	                --       AND PDPG.ADT_COST > 0
	                --GROUP BY
	                --       PDPG.PRO_CODE
	            ) PDPG_LIST
	            ON  TPL.PRO_CODE = PDPG_LIST.PRO_CODE
	WHERE  1 = 1
	
	---------------------------------------------------------------
	-- 예약수
	---------------------------------------------------------------
	UPDATE TPL
	SET    TPL.RES_COUNT = RM_LIST.RES_COUNT
	FROM   #TMP_PRO_LIST TPL
	       INNER JOIN (
	                SELECT RM.PRO_CODE
	                      ,COUNT(*) RES_COUNT
	                FROM   dbo.RES_MASTER_damo RM WITH(NOLOCK)
	                       INNER JOIN dbo.RES_CUSTOMER_damo RC WITH(NOLOCK)
	     ON  RM.RES_CODE = RC.RES_CODE
	                WHERE  RM.PRO_CODE IN (SELECT PRO_CODE
	                                       FROM   #TMP_PRO_LIST)
	                       AND RM.RES_STATE <= 7
	                       AND RC.RES_STATE = 0
	                GROUP BY
	                       RM.PRO_CODE
	            ) RM_LIST
	            ON  TPL.PRO_CODE = RM_LIST.PRO_CODE
	WHERE  1 = 1
	
	---------------------------------------------------------------
	-- 항공정보
	---------------------------------------------------------------
	UPDATE TPL
	SET    TPL.departBgnDy = PD_LIST.departBgnDy
	      ,TPL.departBgnTime = PD_LIST.departBgnTime
	      ,TPL.departAirNo = PD_LIST.departAirNo
	      ,TPL.departAirlineCd = PD_LIST.departAirlineCd
	      ,TPL.arrivalEndDy = PD_LIST.arrivalEndDy
	      ,TPL.arrivalEndTime = PD_LIST.arrivalEndTime
	      ,TPL.arrivalAirNo = PD_LIST.arrivalAirNo
	      ,TPL.arrivalAirlineCd = PD_LIST.arrivalAirlineCd
	      ,TPL.departEndDy = PD_LIST.departEndDy -- 출국도착일자
	      ,TPL.departEndTime = PD_LIST.departEndTime -- 출국도착시간
	      ,TPL.arrivalBgnDy = PD_LIST.arrivalBgnDy -- 귀국출발일자
	      ,TPL.arrivalBgnTime = PD_LIST.arrivalBgnTime -- 귀국출발시간
	      ,TPL.DEP_FLYING_SEC = PD_LIST.DEP_FLYING_SEC
	      ,TPL.ARR_FLYING_SEC = PD_LIST.ARR_FLYING_SEC
	      ,TPL.departTotalTime = PD_LIST.departTotalTime
	      ,TPL.arrivalTotalTime = PD_LIST.arrivalTotalTime
	      ,TPL.SeatClass = PD_LIST.SeatClass
	      ,TPL.DEP_TRANSIT_COUNT = PD_LIST.DEP_TRANSIT_COUNT
	      ,TPL.ARR_TRANSIT_COUNT = PD_LIST.ARR_TRANSIT_COUNT
	FROM   #TMP_PRO_LIST TPL
	       INNER JOIN (
	                SELECT PD.PRO_CODE
	                      ,MIN(CONVERT(VARCHAR(10) ,PTS.DEP_DEP_DATE ,111)) AS departBgnDy
	                      ,MIN(REPLACE(PTS.DEP_DEP_TIME ,':' ,'')) AS departBgnTime
	                      ,MIN(PTS.DEP_TRANS_CODE + PTS.DEP_TRANS_NUMBER) AS departAirNo
	                      ,ISNULL(
	                           (
	                               SELECT EST_AIRLINE_NAME
	                               FROM   EST_AIRLINE_ATTR_MAP EAAM WITH(NOLOCK)
	                               WHERE  EAAM.AIRLINE_CODE = MIN(PTS.DEP_TRANS_CODE)
	                           )
	                          ,'기타'
	                       ) AS departAirlineCd
	                      ,MIN(CONVERT(VARCHAR(10) ,PTS.ARR_ARR_DATE ,111)) AS arrivalEndDy
	                      ,MIN(REPLACE(PTS.ARR_ARR_TIME ,':' ,'')) AS arrivalEndTime
	                      ,MIN(PTS.ARR_TRANS_CODE + PTS.ARR_TRANS_NUMBER) AS arrivalAirNo
	                      ,ISNULL(
	                           (
	                               SELECT EST_AIRLINE_NAME
	                               FROM   EST_AIRLINE_ATTR_MAP EAAM WITH(NOLOCK)
	                               WHERE  EAAM.AIRLINE_CODE = MIN(PTS.ARR_TRANS_CODE)
	                           )
	                          ,'기타'
	                       ) AS arrivalAirlineCd
	                      ,MIN(CONVERT(VARCHAR(10) ,PTS.DEP_ARR_DATE ,111)) departEndDy -- 출국도착일자
	                      ,MIN(PTS.DEP_ARR_TIME) AS departEndTime -- 출국도착시간
	                      ,MIN(CONVERT(VARCHAR(10) ,PTS.ARR_DEP_DATE ,111)) arrivalBgnDy -- 귀국출발일자
	                      ,MIN(PTS.ARR_DEP_TIME) AS arrivalBgnTime -- 귀국출발시간
	                      ,SUM(CASE WHEN CHARINDEX(':' ,PTSS.FLYING_TIME) > 0 AND PTSS.TRANS_SEQ = 1 THEN DATEDIFF(S ,'1900-01-01' ,CONVERT(DATETIME ,PTSS.FLYING_TIME)) ELSE 0 END) AS DEP_FLYING_SEC
	                      ,SUM(CASE WHEN CHARINDEX(':' ,PTSS.FLYING_TIME) > 0 AND PTSS.TRANS_SEQ = 2 THEN DATEDIFF(S ,'1900-01-01' ,CONVERT(DATETIME ,PTSS.FLYING_TIME)) ELSE 0 END) AS ARR_FLYING_SEC
	                      ,MIN(CASE WHEN CHARINDEX(':' ,PTS.DEP_SPEND_TIME) < 1 THEN '' WHEN LEFT(PTS.DEP_SPEND_TIME ,1) = '0' THEN (SUBSTRING(PTS.DEP_SPEND_TIME ,2 ,1) + '시간 ' + RIGHT(PTS.DEP_SPEND_TIME ,2) + '분') ELSE (LEFT(PTS.DEP_SPEND_TIME ,2) + '시간 ' + RIGHT(PTS.DEP_SPEND_TIME ,2) + '분') END) departTotalTime
	                      ,MIN(CASE WHEN CHARINDEX(':' ,PTS.ARR_SPEND_TIME) < 1 THEN '' WHEN LEFT(PTS.ARR_SPEND_TIME ,1) = '0' THEN (SUBSTRING(PTS.ARR_SPEND_TIME ,2 ,1) + '시간 ' + RIGHT(PTS.ARR_SPEND_TIME ,2) + '분') ELSE (LEFT(PTS.ARR_SPEND_TIME ,2) + '시간 ' + RIGHT(PTS.ARR_SPEND_TIME ,2) + '분') END) arrivalTotalTime
	                      ,(CASE MIN(PTS.FARE_SEAT_TYPE) WHEN 2 THEN '프리미엄일반석' WHEN 3 THEN '비지니스' WHEN 4 THEN '일등석' ELSE '일반석' END) SeatClass
	                      ,SUM(CASE WHEN PTSS.SEAT_CODE IS NULL THEN -1 WHEN PTSS.TRANS_SEQ = 1 THEN 1 ELSE 0 END) DEP_TRANSIT_COUNT
	                      ,SUM(CASE WHEN PTSS.SEAT_CODE IS NULL THEN -1 WHEN PTSS.TRANS_SEQ = 2 THEN 1 ELSE 0 END) ARR_TRANSIT_COUNT
	                FROM   dbo.PKG_DETAIL PD WITH(NOLOCK)
	                       INNER JOIN dbo.PRO_TRANS_SEAT PTS WITH(NOLOCK)
	                            ON  PD.SEAT_CODE = PTS.SEAT_CODE
	                       LEFT JOIN dbo.PRO_TRANS_SEAT_SEGMENT PTSS WITH(NOLOCK)
	                            ON  PTS.SEAT_CODE = PTSS.SEAT_CODE
	                WHERE  PD.PRO_CODE IN (SELECT PRO_CODE
	                                       FROM   #TMP_PRO_LIST)
	                GROUP BY
	                       PD.PRO_CODE
	            ) PD_LIST
	            ON  TPL.PRO_CODE = PD_LIST.PRO_CODE
	WHERE  1 = 1
	;
	
	---------------------------------------------------------------
	-- 검색
	---------------------------------------------------------------
	SELECT *
	FROM   (
	           SELECT PD.PRO_CODE + '|' + CONVERT(VARCHAR ,VPDP.PRICE_SEQ) AS itemNo
	                 ,PD.PRO_NAME AS itemNm
	                 ,TPL.departBgnDy
	                 ,TPL.departBgnTime
	                 ,TPL.departAirNo
	                 ,TPL.departAirlineCd
	                 ,TPL.arrivalEndDy
	                 ,TPL.arrivalEndTime
	                 ,TPL.arrivalAirNo
	                 ,TPL.arrivalAirlineCd
	                 ,(CASE WHEN PD.TOUR_NIGHT = 0 THEN '당일' ELSE CONVERT(VARCHAR ,PD.TOUR_NIGHT) + '박' END) AS itemTourNightDays
	                 ,(CONVERT(VARCHAR ,PD.TOUR_DAY) + '일') AS itemTourDays
	                 ,(
	                      CASE 
	                           WHEN PD.RES_ADD_YN = 'Y'
	                      AND PD.MAX_COUNT = -1 THEN '30' -- 대기예약(02)
	                          WHEN PD.RES_ADD_YN = 'Y'
	                      AND (PD.MAX_COUNT = 0 OR (PD.MAX_COUNT - ISNULL(TPL.RES_COUNT ,0)) > 0) THEN '10' -- 예약가능(01)
	                          ELSE '40' -- 예약마감(03)
	                          END
	                  ) AS rsvStatCd
	                 ,VPDP.ADT_SALE_PRICE AS selPrc -- 정상가
	                 ,VPDP.ADT_PRICE AS adultSelPrc -- 성인가
	                 ,'02' AS adultTaxType -- 성인 유류세 타입 (01 : %, 02 : 원)
	                 ,VPDP.ADT_SALE_QCHARGE AS adultTaxPrc -- 성인 유류세 금액
	                 ,'02' AS adultBillType -- 성인 제세공과금 타입 (01 : %, 02 : 원)
	                 ,'0' AS adultBillPrc -- 성인 제세공과금 금액
	                 ,VPDP.CHD_PRICE AS childSelPrc -- 아동가
	                 ,'02' AS childTaxType -- 아동 유류세 타입 (01 : %, 02 : 원)
	                 ,VPDP.CHD_SALE_QCHARGE AS childTaxPrc -- 아동 유류세 금액
	                 ,'02' AS childBillType -- 아동 제세공과금 타입 (01 : %, 02 : 원)
	                 ,'0' AS childBillPrc -- 아동 제세공과금 금액
	                 ,VPDP.INF_PRICE AS babySelPrc -- 유아가
	                 ,'02' AS babyTaxType -- 유아 유류세 타입 (01 : %, 02 : 원)
	                 ,VPDP.INF_SALE_QCHARGE AS babyTaxPrc -- 유아 유류세 금액
	                 ,'02' AS babyBillType -- 유아 제세공과금 타입 (01 : %, 02 : 원)
	                 ,'0' AS babyBillPrc -- 유아 제세공과금 금액
	                 --,(CASE WHEN PD.MAX_COUNT = 0 THEN 99 WHEN PD.MAX_COUNT > 0 THEN (PD.MAX_COUNT - ISNULL(TPL.RES_COUNT ,0) - PD.FAKE_COUNT) ELSE 0 END) AS remainQty2 -- 총 확보좌석
	                 --,(CASE WHEN PD.MAX_COUNT = -1 THEN 0 ELSE ((CASE WHEN PD.MAX_COUNT = 0 THEN 30 ELSE PD.MAX_COUNT END) - ISNULL(TPL.RES_COUNT ,0) - PD.FAKE_COUNT) END) AS remainQty
					 ,(CASE WHEN PD.MAX_COUNT = -1 THEN 0 ELSE (CASE WHEN PD.MAX_COUNT = 0 THEN 30 ELSE PD.MAX_COUNT END) END) AS remainQty -- 총 확보좌석
					 ,(CASE WHEN PD.MAX_COUNT = -1 THEN 0 ELSE ((CASE WHEN PD.MAX_COUNT = 0 THEN 30 ELSE PD.MAX_COUNT END) - ISNULL(TPL.RES_COUNT ,0) - PD.FAKE_COUNT) END) AS qty -- 잔여좌석수량
	                 ,ISNULL(PD.MIN_COUNT ,'0') AS MINSelQty -- 출발최소인원
	                 ,'/Product/Package/PackageDetail?ProCode=' + PD.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR ,VPDP.PRICE_SEQ) + '&IsProvider=Y&ProviderCode=11st' AS prdDetailUrl -- 상품상세 url ( iframeDetailYn이 Y인 경우 필수 )	--'/Mobile/Product/PackageDetail?ProCode=' + PD.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR, VPDP.PRICE_SEQ) + '&ProviderCode=11st' AS prdDetailUrlMobile, -- 모바일 상품상세 url ( iframeDetailYn이 Y인 경우 필수 )
	                 ,'/Mobile/Affiliate/EstPackageInfo?ProCode=' + PD.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR ,VPDP.PRICE_SEQ) AS prdDetailUrlMobile -- 변경
	                 ,'' AS itemPromotionFlag -- 상품프로모션 플래그
	                 ,'/Content/Info/IndividualInfo/StandardTerm.html' AS tourBasicAgreement -- 여행약관
	                 ,(CASE WHEN ISNULL(PD.PKG_CONTRACT ,'') = '' THEN '' ELSE '/Support/TravelRule?ProCode=' + PD.PRO_CODE END) AS tourAddAgreement -- 추가약관
	                 ,'' AS tourCityList
	                 ,'/Mobile/Affiliate/EstPackageInfo?ProCode=' + PD.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR ,VPDP.PRICE_SEQ) + '&Type=REVIEW' AS spclBnftInfoUrl -- 모바일 특성안내
	                 --,'' AS inclInfoUrl
	                 --,'' AS excldInfoUrl
	                 ,'/Mobile/Affiliate/EstPackageInfo?ProCode=' + PD.PRO_CODE + '&PriceSeq=' + CONVERT(VARCHAR ,VPDP.PRICE_SEQ) + '&Type=REMARK' AS cautUrl -- 모바일 유의사항
	                 ,ISNULL(TPL.shoppingCount ,0) AS shoppingCount
	                 ,'<table class=''include_state'' style=''width:100%;position:relative;border-top:1px solid #ddd;border-left:1px solid #ddd;table-layout:fixed''><caption></caption><colgroup><col style=''width:50%''><col style=''width:50%''></colgroup><thead><tr style=''border-bottom:1px solid #ddd''><th style=''padding:12px 0;text-align:center;background:#f5f9fd;line-height:23px;border-right:1px solid #ddd;vertical-align:top;word-wrap:break-word''><img src=''https://www.verygoodtour.com/Images/2013/Common/icon_O_1.png'' alt=''O''> 포함사항</th><th style=''padding:12px 0;text-align:center;background:#f5f9fd;line-height:23px;border-right:1px solid #ddd;vertical-align:top;word-wrap:break-word''><img src=''https://www.verygoodtour.com/Images/2013/Common/icon_X_1.png'' alt=''O''> 불포함사항</th></tr></thead><tbody><tr style=''border-bottom:1px solid #ddd''><td style=''border-right:1px solid #ddd;text-align:left;padding:24px;vertical-align:top;word-wrap:break-word''>'
									+ REPLACE(PR.PKG_INCLUDE,CHAR(13),'<br>') -- [포함]
									+ '</td><td style=''border-right:1px solid #ddd;text-align:left;padding:24px;vertical-align:top;word-wrap:break-word''>'
									+ REPLACE(PR.PKG_NOT_INCLUDE,CHAR(13),'<br>') -- [불포함]
									+ '</td></tr></tbody></table><br>'
									+ PD.PKG_REVIEW AS prdDetailInfo --상품상세(리뷰?)
	                 ,ISNULL(TPL.mealCount ,0) AS mealCount -- 식사횟수
	                 ,ISNULL(TPL.guideFeeYn ,'N') AS guideFeeYn -- 팁여부
	                 ,ISNULL(PDO.optionalTourInfo ,'') AS optionalTourInfo --선택관광정보
	                 ,(CASE PM.ATT_CODE WHEN '2' THEN '1억' ELSE CASE PM.SIGN_CODE WHEN 'K' THEN '5천' ELSE '1억' END END) AS insuranceAmount
	                 ,TPL.departEndDy -- 출국도착일자
	                 ,TPL.departEndTime -- 출국도착시간
	                 ,TPL.arrivalBgnDy -- 귀국출발일자
	                 ,TPL.arrivalBgnTime -- 귀국출발시간
	                 ,(CASE WHEN TPL.DEP_FLYING_SEC > 0 THEN (CONVERT(VARCHAR(10) ,TPL.DEP_FLYING_SEC / 3600) + '시간 ' + RIGHT('0' + CONVERT(VARCHAR(2) ,(TPL.DEP_FLYING_SEC % 3600) / 60) ,2) + '분') ELSE '' END) departFlightTime -- 출발 총 비행시간
	                 ,(CASE WHEN TPL.DEP_FLYING_SEC > 0 THEN (CONVERT(VARCHAR(10) ,TPL.ARR_FLYING_SEC / 3600) + '시간 ' + RIGHT('0' + CONVERT(VARCHAR(2) ,(TPL.ARR_FLYING_SEC % 3600) / 60) ,2) + '분') ELSE '' END) arrivalFlightTime -- 출발 총 비행시간
	                 ,TPL.departTotalTime -- 출발 총 시간
	                 ,TPL.arrivalTotalTime -- 도착 총 시간
	                 ,TPL.SeatClass AS departSeatClass
	                 ,TPL.SeatClass AS arrivalSeatClass
	                 ,(CASE WHEN TPL.DEP_FLYING_SEC > 0 THEN (TPL.DEP_TRANSIT_COUNT - 1) ELSE NULL END) departTransitCount -- 출국 경유횟수
	                 ,(CASE WHEN TPL.DEP_FLYING_SEC > 0 THEN (TPL.ARR_TRANSIT_COUNT - 1) ELSE NULL END) arrivalTransitCount -- 귀국 경유횟수
	           FROM   #TMP_PRO_LIST TPL
	                  INNER JOIN dbo.PKG_DETAIL PD
	                       ON  TPL.PRO_CODE = PD.PRO_CODE
	                  INNER JOIN dbo.VIEW_PRO_DETAIL_PRICE VPDP
	                       ON  PD.PRO_CODE = VPDP.PRO_CODE
	                  INNER JOIN dbo.PKG_MASTER PM
	                       ON  PD.MASTER_CODE = PM.MASTER_CODE
	                   INNER JOIN PKG_DETAIL_PRICE PR ON PR.PRO_CODE = PD.PRO_CODE --[ 포함 / 불포함 추가]
	                   CROSS APPLY (
						   SELECT STUFF(
										  (
											  SELECT ',' + PDO.OPT_NAME
											  FROM   PKG_DETAIL_OPTION PDO
											  WHERE  PDO.PRO_CODE = TPL.PRO_CODE
													 FOR XML PATH('')
										  ) ,1,1 ,'' ) AS optionalTourInfo
					       ) PDO
	                   ) T
	WHERE  --T.remainQty > 0 -- 좌석있고
		   T.qty > 0 
	       AND T.rsvStatCd = '10' -- 예약가능만(01)
	ORDER BY
	       T.itemNo ASC
	;
END
GO
