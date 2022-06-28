USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: XP_PRO_AIRLINE_QCHARGE_INSERT
■ DESCRIPTION				: 항공사 지역별 유류할증료 일괄 등록
■ INPUT PARAMETER			: 
	@XML NVARCHAR(MAX)		: AirlineQchargeRQ 클래스의 SerializeXml 문자열
■ OUTPUT PARAMETER			: 
■ EXEC						: 

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-01-22		김성호			최초생성
   2014-01-24		김성호			등록시 이전 END_DATE 업데이트
   2014-06-17		박형만			QchargePrice -> Adult,Child,Infant 로 세분화
   2022-03-23		오정민			유류할증료 수정지역에 해당하는 Naver 연동상품의 유류할증료 갱신을 위해
									연동대상 테이블(NTT_PKG_DETAIL_UPDATE_TARGET)에 데이터추가
   2022-04-01		오정민			유류할증료 적용기간에 구애받지않도록 유류할증료 EndDate필터조건 제거
   2022-04-27		김성호			출발일 오늘 이후 조건 추가
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[XP_PRO_AIRLINE_QCHARGE_INSERT]
(
	@XML	NVARCHAR(MAX)
) 
AS 
BEGIN

	DECLARE @DOCHANDLE INT

	EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @XML;

	BEGIN TRY

	BEGIN TRAN

	UPDATE A SET A.END_DATE = B.START_DATE
	FROM AIRLINE_QCHARGE A
	INNER JOIN OPENXML(@DOCHANDLE, N'/ArrayOfAirlineQChargeRQ/AirlineQChargeRQ', 0)
	WITH
	(
		AIRLINE_CODE	CHAR(2)		'./AirlineCode',
		GROUP_SEQ		INT			'./GroupSeq',
		REGION_SEQ		INT			'./RegionSeq',
		QCHARGE_SEQ		INT			'./QChargeSeq',
		START_DATE		DATETIME	'./StartDate',
		END_DATE		DATETIME	'./EndDate',
		ADT_QCHARGE		INT		'./AdultQCharge',
		CHD_QCHARGE		INT		'./ChildQCharge',
		INF_QCHARGE		INT		'./InfantQCharge',
		NEW_CODE		CHAR(7)		'./NewCode'
	) B ON A.AIRLINE_CODE = B.AIRLINE_CODE AND A.GROUP_SEQ = B.GROUP_SEQ AND A.REGION_SEQ = B.REGION_SEQ AND A.QCHARGE_SEQ = B.QCHARGE_SEQ
	WHERE A.END_DATE = '3000-01-01' AND B.END_DATE = '3000-01-01';

	INSERT INTO AIRLINE_QCHARGE (AIRLINE_CODE, GROUP_SEQ, REGION_SEQ, QCHARGE_SEQ, 
		START_DATE, END_DATE, ADT_QCHARGE, CHD_QCHARGE,INF_QCHARGE,NEW_CODE, NEW_DATE)
	SELECT A.AIRLINE_CODE, A.GROUP_SEQ, A.REGION_SEQ
		, ISNULL((SELECT MAX(QCHARGE_SEQ) FROM AIRLINE_QCHARGE AA WITH(NOLOCK) 
			WHERE AA.AIRLINE_CODE = A.AIRLINE_CODE AND AA.GROUP_SEQ = A.GROUP_SEQ AND AA.REGION_SEQ = A.REGION_SEQ), 0) + 1
		, A.START_DATE, A.END_DATE, A.ADT_QCHARGE,A.CHD_QCHARGE,A.INF_QCHARGE, A.NEW_CODE, GETDATE()
	FROM OPENXML(@DOCHANDLE, N'/ArrayOfAirlineQChargeRQ/AirlineQChargeRQ', 0)
	WITH
	(
		AIRLINE_CODE	CHAR(2)		'./AirlineCode',
		GROUP_SEQ		INT			'./GroupSeq',
		REGION_SEQ		INT			'./RegionSeq',
		QCHARGE_SEQ		INT			'./QChargeSeq',
		START_DATE		DATETIME	'./StartDate',
		END_DATE		DATETIME	'./EndDate',
		ADT_QCHARGE		INT		'./AdultQCharge',
		CHD_QCHARGE		INT		'./ChildQCharge',
		INF_QCHARGE		INT		'./InfantQCharge',
		NEW_CODE		CHAR(7)		'./NewCode'
	) A;

	COMMIT TRAN
	
	-- Naver 연동상품의 유류할증료 갱신을위한 로직 시작
	
	DECLARE @xmldata as xml;
	SELECT @xmldata = CAST(REPLACE(@XML, 'encoding="UTF-8"', '') as XML)
	
	-- 임시테이블
	IF (OBJECT_ID('tempdb..#TMP_NTT_UPDATE_LIST') IS NOT NULL)
		BEGIN
		    DROP TABLE #TMP_NTT_UPDATE_LIST;
		END
		
	CREATE TABLE #TMP_NTT_UPDATE_LIST
	(
		PRO_CODE              VARCHAR(20) NOT NULL
		,PRICE_SEQ             INT NOT NULL				
		,MASTER_CODE           VARCHAR(10) NOT NULL
		,BIT_CODE              VARCHAR(4) NOT NULL
		,NEW_CODE              VARCHAR(7) NOT NULL
	);
	CREATE NONCLUSTERED INDEX #IDX_TMP_NTT_UPDATE_LIST ON #TMP_NTT_UPDATE_LIST(PRO_CODE, PRICE_SEQ);
	CREATE NONCLUSTERED INDEX #IDX_TMP_NTT_UPDATE_LIST_2 ON #TMP_NTT_UPDATE_LIST(MASTER_CODE, BIT_CODE);
	
	INSERT INTO #TMP_NTT_UPDATE_LIST (PRO_CODE, PRICE_SEQ, MASTER_CODE, BIT_CODE, NEW_CODE)
	SELECT PD.PRO_CODE
	      ,PDP.PRICE_SEQ
	      ,PD.MASTER_CODE
	      ,SUBSTRING(REPLACE(PD.PRO_CODE ,PD.MASTER_CODE ,'') ,8 ,4) AS BIT_CODE
	      ,AQ.NEW_CODE
	FROM   (
	           SELECT AQ.n.value('(AirlineCode/text())[1]' ,'CHAR(2)') AS AIRLINE_CODE
	                 ,AQ.n.value('(GroupSeq/text())[1]' ,'INT') AS GROUP_SEQ
	                 ,AQ.n.value('(RegionSeq/text())[1]' ,'INT') AS REGION_SEQ
	                 ,AQ.n.value('(StartDate/text())[1]' ,'DATETIME') AS START_DATE
	                 ,AQ.n.value('(EndDate/text())[1]' ,'DATETIME') AS END_DATE
	                 ,AQ.n.value('(NewCode/text())[1]' ,'VARCHAR(7)') AS NEW_CODE
	                 ,AR.NATION_CODES
	                 ,AR.AIRPORT_CODES
	                 ,(
	                      ISNULL(AR.AIRPORT_CODES, '') + ISNULL(
	                          (
	                              SELECT (',' + PA.AIRPORT_CODE) AS [text()]
	                              FROM   dbo.PUB_NATION PN WITH(NOLOCK)
	                                     INNER JOIN dbo.PUB_CITY PC WITH(NOLOCK)
	                                          ON  PN.NATION_CODE = PC.NATION_CODE
	                                     INNER JOIN dbo.PUB_AIRPORT PA WITH(NOLOCK)
	                                          ON  PC.CITY_CODE = PA.CITY_CODE
	                              WHERE  PN.NATION_CODE IN ('SG') --IN (AR.NATION_CODES)
	                                     FOR XML PATH('')
	                          )
	                         ,''
	                      )
	                  ) AS [TOTAL_AIRPORT_CODES]
	           FROM   @xmldata.nodes(N'/ArrayOfAirlineQChargeRQ/AirlineQChargeRQ') AS AQ(n)
	                  INNER JOIN AIRLINE_REGION AR WITH(NOLOCK)
	                       ON  AR.AIRLINE_CODE = AQ.n.value('(AirlineCode/text())[1]' ,'CHAR(2)')
	                           AND AR.GROUP_SEQ = AQ.n.value('(GroupSeq/text())[1]' ,'INT')
	                           AND AR.REGION_SEQ = AQ.n.value('(RegionSeq/text())[1]' ,'INT')
	       ) AQ
	       INNER JOIN PRO_TRANS_SEAT PTS WITH(NOLOCK)
	            ON  AQ.AIRLINE_CODE = PTS.DEP_TRANS_CODE
	                AND AQ.START_DATE <= PTS.DEP_DEP_DATE
	                AND CHARINDEX(PTS.DEP_ARR_AIRPORT_CODE ,AQ.TOTAL_AIRPORT_CODES ,0) > 0
	                AND PTS.DEP_DEP_DATE > GETDATE()
	       INNER JOIN PKG_DETAIL PD WITH(NOLOCK ,INDEX(IDX_PKG_DETAIL_4))
	            ON  PTS.SEAT_CODE = PD.SEAT_CODE AND PD.DEP_DATE > GETDATE()
	       INNER JOIN PKG_DETAIL_PRICE PDP WITH(NOLOCK)
	            ON  PD.PRO_CODE = PDP.PRO_CODE;
	
	-- 연동대상 테이블 등록
	INSERT INTO dbo.NTT_PKG_DETAIL_UPDATE_TARGET (MASTER_CODE, PRO_CODE, PRICE_SEQ, BIT_CODE, NEW_DATE, NEW_CODE)
	SELECT TMP.MASTER_CODE
	      ,TMP.PRO_CODE
	      ,TMP.PRICE_SEQ
	      ,TMP.BIT_CODE
	      ,GETDATE() AS NEW_DATE
	      ,TMP.NEW_CODE AS NEW_CODE
	FROM   #TMP_NTT_UPDATE_LIST TMP
	       INNER JOIN dbo.PKG_MASTER_AFFILIATE PMA WITH(NOLOCK)
	            ON  TMP.MASTER_CODE = PMA.MASTER_CODE
	                AND TMP.BIT_CODE = PMA.BIT_CODE
	                AND PMA.PROVIDER = 41 -- 네이버
	                AND PMA.USE_YN = 'Y'
	       LEFT JOIN dbo.NTT_PKG_DETAIL_UPDATE_TARGET NUT WITH(NOLOCK, INDEX(IDX_NTT_PKG_DETAIL_UPDATE_TARGET_2))
	            ON  NUT.PRO_CODE = TMP.PRO_CODE
	                AND NUT.PRICE_SEQ = TMP.PRICE_SEQ
	                AND NUT.CHK_DATE IS NULL
	                AND NUT.NEW_DATE > DATEADD(MM, -1, GETDATE())
	WHERE  NUT.SEQ_NO IS NULL
	
	-- Naver 연동상품의 유류할증료 갱신을위한 로직 끝

	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH

	EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE

END 

GO
