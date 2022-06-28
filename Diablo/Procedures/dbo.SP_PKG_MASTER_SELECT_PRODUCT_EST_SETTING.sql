USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SELECT_PRODUCT_EST_SETTING
■ DESCRIPTION				: 11번가 상품연동
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_PKG_MASTER_SELECT_PRODUCT_EST_SETTING
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2015-12-03			정지용			최초생성
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_EST_SETTING]
AS
BEGIN
	SET NOCOUNT ON 
	/* 11번가 PROVIDER 코드 */
	-- SELECT * FROM COD_PUBLIC WHERE PUB_TYPE = 'RES.AGENT.TYPE'
	DECLARE @PROVIDER_TST INT 
	SET @PROVIDER_TST = 31

	DECLARE @MASTER_CODE_TBL TABLE ( MASTER_CODE VARCHAR(20) ) 

	------------------------------------------------------------------
	--대상 마스터 코드 조회 및 임시 저장 
	------------------------------------------------------------------
	INSERT INTO @MASTER_CODE_TBL		
	SELECT 
		UPPER(A.MASTER_CODE) AS MASTER_CODE
	FROM PKG_MASTER AS A WITH(NOLOCK)
	INNER JOIN PKG_FILE_MANAGER AS PFM WITH(NOLOCK) ON A.MASTER_CODE = PFM.MASTER_CODE -- 상품이미지 필수
		AND PFM.FILE_CODE = ( 
			SELECT 
				TOP 1 PFM1.FILE_CODE 
			FROM PKG_FILE_MANAGER PFM1 WITH(NOLOCK)
			INNER JOIN INF_FILE_MASTER AS PFM2 WITH(NOLOCK) ON PFM1.FILE_CODE = PFM2.FILE_CODE
			WHERE PFM1.MASTER_CODE = PFM.MASTER_CODE AND PFM2.SHOW_YN = 'Y' ORDER BY SHOW_ORDER ASC)
	INNER JOIN INF_FILE_MASTER AS IFM WITH(NOLOCK) ON PFM.FILE_CODE = IFM.FILE_CODE
	WHERE A.LAST_DATE >= GETDATE()
			AND A.SHOW_YN  = 'Y' AND A.NEW_CODE NOT IN ('9999999', '2012019', '2013003') -- 시스템 관리자,김민정,이슬아 제외
			AND SUBSTRING(A.MASTER_CODE, 3, 1) <>'F'							-- 자유여행 제외
			AND A.ATT_CODE <> 'W' AND SUBSTRING(A.MASTER_CODE, 3, 1) <> 'W'		-- 허니문 제외
			AND SUBSTRING(A.MASTER_CODE, 3, 1) <> 'B' AND A.BRANCH_CODE <> 1	-- 지방출발 제외

			 
	------------------------------------------------------------------
	--제휴사 관리 테이블 수정및 등록 
	------------------------------------------------------------------	
	UPDATE A SET A.USE_YN = 'N' , A.EDT_DATE = GETDATE() , A.EDT_CODE = '9999999'
	FROM PKG_MASTER_AFFILIATE  A 
		LEFT JOIN @MASTER_CODE_TBL B 
			ON A.MASTER_CODE = B.MASTER_CODE 
			AND A.PROVIDER = @PROVIDER_TST 
	WHERE A.PROVIDER = @PROVIDER_TST 
	AND A.USE_YN = 'Y' --기존 사용중인것
	AND B.MASTER_CODE IS NULL;

	--기존에 없는 신규추가된것.제휴사 관리 테이블에 자동 데이터 입력 
	INSERT INTO PKG_MASTER_AFFILIATE (MASTER_CODE , AFF_TYPE , NEW_DATE, NEW_CODE, USE_YN, PROVIDER)
	SELECT MASTER_CODE, 7,  GETDATE() , '9999999' , 'Y' , @PROVIDER_TST  
	FROM @MASTER_CODE_TBL 
	WHERE MASTER_CODE NOT IN ( SELECT MASTER_CODE FROM PKG_MASTER_AFFILIATE  WITH(NOLOCK) WHERE PROVIDER = @PROVIDER_TST  );

	------------------------------------------------------------------
	-- 대상 상품 조회 ( 제휴사 관리 테이블 기준  )
	------------------------------------------------------------------
	SELECT
	 	UPPER(PM.MASTER_CODE) AS [PKG_MST_CODE], PM.MASTER_NAME AS [PKG_MST_NAME]
	FROM PKG_MASTER_AFFILIATE A 
	INNER JOIN PKG_MASTER AS PM WITH(NOLOCK)
		ON A.MASTER_CODE  = PM.MASTER_CODE 
			AND A.PROVIDER = @PROVIDER_TST 
END

GO
