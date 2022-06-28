USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SELECT_PRODUCT_NAVER_SETTING_NEW
■ DESCRIPTION				: 2019 네이버 패키지 상품연동_ 테스트 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: SP_PKG_MASTER_SELECT_PRODUCT_NAVER_SETTING_NEW ''

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2019-03-18			박형만			
2019-05-16			박형만  임시테이블 에서 조회 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_NAVER_SETTING_NEW]
	@MASTER_CODE VARCHAR(10)  = null 
AS
BEGIN

	
	-------------전체 마스터 일때 만 백업---------------------------
	--IF ISNULL(@MASTER_CODE,'')  = '' 
	--BEGIN

	--	-- 전체 마스터 셋팅 
	--	DECLARE @TMP_TABLE_BAK_SQL VARCHAR(4000)
	--	DECLARE @TMP_SOURCE_TABLE VARCHAR(1000)

	--	DECLARE @TMP_TARGET_DATE VARCHAR(8)
	--	SET @TMP_TARGET_DATE = CONVERT(VARCHAR(8),DATEADD(D,-1,GETDATe()),112 ) 

	----SELECT @TMP_TARGET_DATE
	----SELECT CONVERT(DATETIME,@TMP_TARGET_DATE)
	--	SET @TMP_SOURCE_TABLE = 'NAVER_PKG_MASTER,NAVER_PKG_DETAIL,NAVER_PKG_DETAIL_OPTION,NAVER_PKG_DETAIL_HOTEL,NAVER_PKG_DETAIL_SCH'
	--	------------------------------------------------------------------------------------------------
	--	-- 당일 테이블 백업 
	--	DECLARE @TBL_CNT INT 
	--	SET @TBL_CNT  = 1 
	--	WHILE @TBL_CNT <=  (SELECT MAX(ID) FROM DBO.FN_SPLIT(@TMP_SOURCE_TABLE,',')  )
	--	BEGIN

	--		DECLARE @SOURCE_TABLE VARCHAR(100)
	--		DECLARE @TARGET_TABLE VARCHAR(100)

	--		DECLARE @TARGET_DEL_TABLE VARCHAR(100)

	--		SET @SOURCE_TABLE = (SELECT DATA FROM DBO.FN_SPLIT(@TMP_SOURCE_TABLE,',') WHERE ID = @TBL_CNT )
	--		SET @TARGET_TABLE =  @SOURCE_TABLE+'_'+ @TMP_TARGET_DATE  -- 어제날짜 
	--		SET @TARGET_DEL_TABLE =  @SOURCE_TABLE+'_'+ CONVERT(VARCHAR(8),DATEADD(DD,-1,CONVERT(DATETIME,@TMP_TARGET_DATE)),112 ) 
			
	--		--SELECT DATEADD(DD,-1,CONVERT(DATETIME,'20190325')) 

	--		--SELECT @SOURCE_TABLE ,  @TARGET_TABLE , @TARGET_DEL_TABLE
			
			 
	--		SET @TMP_TABLE_BAK_SQL =  '
	--		IF OBJECT_ID('''+@TARGET_TABLE  +''') IS NOT NULL -- 백업 테이블이 있다면 
	--		BEGIN
	--			DROP TABLE '+@TARGET_TABLE +' -- 백업테이블 지우고 
	--		END 

	--		-- 원본 -> 백업 테이블 이동 
	--		SELECT * INTO '+@TARGET_TABLE +' FROM '+@SOURCE_TABLE+' -- 테이블 이동 

			
	--		--2일전 테이블 삭제 
	--		IF OBJECT_ID('''+@TARGET_DEL_TABLE  +''') IS NOT NULL -- 백업 테이블이 있다면 
	--		BEGIN
	--			DROP TABLE '+@TARGET_DEL_TABLE +' -- 과거 테이블 삭제 
	--		END 
				
	--		---- 원본테이블 삭제 는 하지 않음 
	--		--TRUNCATE '+@SOURCE_TABLE+'	
	--		'

	--		--PRINT (@TMP_TABLE_BAK_SQL ) 
	--		EXEC(@TMP_TABLE_BAK_SQL)

	--		SET @TBL_CNT  = @TBL_CNT + 1 
	--	END 
	--END 
	------------------------------------------------------------
--DECLARE @MASTER_CODE VARCHAR(10) 
--SET @MASTER_CODE= 'EPP545'
	------------------------------------------------------------------
	--대상 마스터 코드 조회 및 임시 저장 
	------------------------------------------------------------------
	-- 생성될 마스터 코드 넣기 
	CREATE TABLE #TMP_PRODUCT (MASTER_CODE VARCHAR(20) , USER_RANK INT ) 			
	
	--INSERT INTO @MASTER_CODE_TBL		
	INSERT INTO #TMP_PRODUCT 
	SELECT MASTER_CODE , ISNULL(USER_RANK,999) FROM NAVER_PKG_MASTER_MANAGE WHERE USE_YN ='Y'   -- 2019-05-16 기준 80% 입력율 넘은것들 은 Y 로 처리 
	AND ( ISNULL(@MASTER_CODE,'')  = '' OR MASTER_CODE = @MASTER_CODE )

	--기존에 없는 신규추가된것.제휴사 관리 테이블에 자동 데이터 입력 
	INSERT INTO PKG_MASTER_AFFILIATE (MASTER_CODE , AFF_TYPE , NEW_DATE, NEW_CODE, USE_YN, PROVIDER)
	SELECT MASTER_CODE, 0,  GETDATE() , '9999999' , 'Y' , 41  
	FROM #TMP_PRODUCT 
	WHERE MASTER_CODE NOT IN ( SELECT MASTER_CODE FROM PKG_MASTER_AFFILIATE  WITH(NOLOCK) WHERE PROVIDER = 41  );

	-- 사용안함을 사용함으로 업데이트 
	UPDATE PKG_MASTER_AFFILIATE 
	SET USE_YN ='Y' , EDT_CODE = '9999999', EDT_DATE = GETDATE() 
--SELECT * FROM PKG_MASTER_AFFILIATE
	WHERE MASTER_CODE IN ( SELECT MASTER_CODE FROM #TMP_PRODUCT ) 
	AND PROVIDER = 41 
	AND USE_YN ='N' 

	------------------------------------------------------------------
	-- 네이버 마스터 테이블 갱신 
	------------------------------------------------------------------
	-- 등록될 마스터 잇을때 
	IF ( SELECT COUNT(*) FROM #TMP_PRODUCT ) > 0 
	BEGIN
		-- 전체일때 
		IF ISNULL(@MASTER_CODE,'')  = '' 
		BEGIN
			-- 전체일때 전체 삭제 
			TRUNCATE TABLE NAVER_PKG_MASTER_NEW
		END 
		ELSE 
		BEGIN
			-- 하나일때, 하나만 삭제  
			DELETE NAVER_PKG_MASTER_NEW
			WHERE MSTCODE IN (SELECT MASTER_CODE FROM #TMP_PRODUCT ) 
		END 

		-- 다시 등록 
		INSERT INTO  NAVER_PKG_MASTER_NEW
		(mstCode,mstTitle,imageUrl,createdDate,updateDate,updateChildCount,useYn,productFamilyRank) 
		SELECT
	 		UPPER(PM.MASTER_CODE) AS mstCode, PM.MASTER_NAME AS mstTitle,
			--패키지 기반 이미지 
			--(CASE
			--	WHEN IFM.FILE_NAME_S = '' THEN ''
			--	WHEN IFM.FILE_NAME_M = '' THEN ('http://contents.verygoodtour.com/content/' + IFM.REGION_CODE + '/' + IFM.NATION_CODE + '/' + IFM.STATE_CODE + '/' + IFM.CITY_CODE + '/image/' + IFM.FILE_NAME_S)
			--	ELSE ('http://contents.verygoodtour.com/content/' + IFM.REGION_CODE + '/' + IFM.NATION_CODE + '/' + IFM.STATE_CODE + '/' + IFM.CITY_CODE + '/image/' + IFM.FILE_NAME_M)
			--END) AS [PKG_IMG_URL]

			-- 마스터 기반 이미지 
			'http://contents.verygoodtour.com/content/' + 
			--CASE WHEN ISNULL(IFM.[FILE_NAME_L],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_L] END AS BIG_IMG,
			IFM.REGION_CODE +'/'+IFM.NATION_CODE +'/'+IFM.STATE_CODE +'/'+IFM.CITY_CODE +'/image/' 
			+(CASE WHEN ISNULL(IFM.[FILE_NAME_M],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_M] END) 
			--CASE WHEN ISNULL(IFM.[FILE_NAME_S],'') ='' THEN IFM.[FILE_NAME] + '.' + IFM.EXTENSION_NAME  ELSE IFM.[FILE_NAME_S] END AS SMALL_IMG,
			AS imageUrl,
			CONVERT(VARCHAR(19),PM.NEW_DATE,121) AS createdDate,
			null AS updateDate ,
			0 , 
			'Y' , 
			-- 랭크 구하기 ,사용자랭킹순,  저번주 예약많은순 , 평균평점높은순  ,코멘트많은순 , , 마스터지역정렬순 , 마스터 코드순 
			RANK() OVER ( ORDER BY Z.USER_RANK ASC, ISNULL(BST.RES_COUNT,-1) DESC , COM.COM_COUNT DESC , COM.AVG_GRADE DESC , PM.REGION_ORDER ASC  , PM.MASTER_CODE )  as productFamilyRank 
			
			--,Z.USER_RANK
			--,BST.RES_COUNT
			--,COM.COM_COUNT
			--,COM.AVG_GRADE
			--,PM.REGION_ORDER 

		FROM #TMP_PRODUCT Z 
		INNER JOIN 	PKG_MASTER_AFFILIATE A 
			ON Z.MASTER_CODE = A.MASTER_CODE 
		INNER JOIN PKG_MASTER AS PM WITH(NOLOCK)
			ON A.MASTER_CODE  = PM.MASTER_CODE 

		-- 마스터 기반 이미지 		
		INNER JOIN INF_FILE_MASTER AS IFM WITH(NOLOCK)
			ON PM.MAIN_FILE_CODE = IFM.FILE_CODE 
	
		-- 패키지 기반 이미지 
		--INNER JOIN PKG_FILE_MANAGER AS PFM WITH(NOLOCK )
		--	ON PM.MASTER_CODE = PFM.MASTER_CODE
		--	AND PFM.FILE_CODE = ( SELECT TOP 1 S1.FILE_CODE FROM PKG_FILE_MANAGER AS S1 WITH(NOLOCK)
		--					INNER JOIN INF_FILE_MASTER AS S2 WITH(NOLOCK)
		--						ON S1.FILE_CODE = S2.FILE_CODE 
		--					WHERE S1.MASTER_CODE = PFM.MASTER_CODE 
		--					AND S2.SHOW_YN = 'Y'
		--					ORDER BY SHOW_ORDER ) 
		--INNER JOIN INF_FILE_MASTER AS IFM WITH(NOLOCK)
		--	ON PFM.FILE_CODE = IFM.FILE_CODE

		LEFT JOIN  PKG_BEST BST 
			ON A.MASTER_CODE = BST.MASTER_CODE 
			AND BASIS_DAY = ( SELECT MAX(BASIS_DAY) FROM PKG_BEST )

		LEFT JOIN (
			select MASTER_CODE , AVG(CONVERT(DECIMAL,GRADE) )AS AVG_GRADE , COUNT(*) AS COM_COUNT from PRO_COMMENT 
			GROUP BY MASTER_CODE 
		) COM
			ON A.MASTER_CODE = COM.MASTER_CODE 
	
		WHERE A.PROVIDER = 41    
		AND A.USE_YN ='Y' -- @PROVIDER 
		--AND A.MASTER_CODE IN (SELECT MASTER_CODE FROM #TMP_PRODUCT) 


		-- 1개의 마스터 일때 
		-- 마스터코드 순위 재갱신 
		IF ( SELECT COUNT(*) FROM #TMP_PRODUCT ) > 0 
		BEGIN
			--SELECT A.MSTCODE, BST.RES_COUNT, COM.COM_COUNT,
			--RANK() OVER ( ORDER BY ISNULL(BST.RES_COUNT,-1) DESC , COM.COM_COUNT DESC , COM.AVG_GRADE DESC , PM.REGION_ORDER ASC  , PM.MASTER_CODE )  as productFamilyRank 
			----,* 
			UPDATE T1 SET productFamilyRank = T2.PRO_RANK
			--SELECT T2.* 
			FROM NAVER_PKG_MASTER_NEW T1
			INNER JOIN 
			(
			SELECT MSTCODE , RANK() OVER ( ORDER BY ISNULL(Z.USER_RANK,999) ASC, ISNULL(BST.RES_COUNT,-1) DESC , COM.COM_COUNT DESC , COM.AVG_GRADE DESC , PM.REGION_ORDER ASC  , PM.MASTER_CODE )  AS PRO_RANK
			FROM NAVER_PKG_MASTER_NEW A 
				INNER JOIN PKG_MASTER PM 
					ON A.MSTCODE  = PM.MASTER_CODE 
				INNER JOIN NAVER_PKG_MASTER_MANAGE Z
					ON PM.MASTER_CODE = Z.MASTER_CODE 
					 
				LEFT JOIN  PKG_BEST BST 
					ON A.MSTCODE = BST.MASTER_CODE 
					AND BASIS_DAY = ( SELECT MAX(BASIS_DAY) FROM PKG_BEST )
			
				LEFT JOIN (
					select MASTER_CODE , AVG(CONVERT(DECIMAL,GRADE) )AS AVG_GRADE , COUNT(*) AS COM_COUNT from PRO_COMMENT 
					GROUP BY MASTER_CODE 
				) COM
					ON A.MSTCODE = COM.MASTER_CODE 
			) T2
				ON T1.MSTCODE = T2.MSTCODE 
	
		END 

		----------------------------------------------------------------------------
		--최종조회 
		SELECT * FROM NAVER_PKG_MASTER_NEW
		WHERE useYn ='Y' 
		AND MSTCODE IN (SELECT MASTER_CODE FROM #TMP_PRODUCT) 
		----------------------------------------------------------------------------
		
	END 

	-- 임시테이블 삭제 
	DROP TABLE #TMP_PRODUCT 


END 

GO
