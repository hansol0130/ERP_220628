USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SELECT_PRODUCT_HYUNDAICARD_SETTING
■ DESCRIPTION				: 현대카드 상품연동
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: EXEC SP_PKG_MASTER_SELECT_PRODUCT_HYUNDAICARD_SETTING 2
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2015-09-07			정지용			최초생성
2016-12-14			정지용			국내상품 추가
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_HYUNDAICARD_SETTING]
	@TYPE INT -- 1 : 해외 / 2 : 국내
AS
BEGIN
	SET NOCOUNT ON 
	/* 현대카드 PROVIDER 코드 */
	-- SELECT * FROM COD_PUBLIC WHERE PUB_TYPE = 'RES.AGENT.TYPE'
	DECLARE @PROVIDER_HYUNDAICARD INT 
	SET @PROVIDER_HYUNDAICARD = 29

	-- AFF_TYPE 안쓰는 필드라 해외/국내 구분하기위해 사용
	DECLARE @AFF_TYPE INT;
	IF @TYPE = 1
	BEGIN
		SET @AFF_TYPE = 6; -- 해외
	END
	ELSE 
	BEGIN
		SET @AFF_TYPE = 7; -- 국내
	END


	DECLARE @MASTER_CODE_TBL TABLE ( MASTER_CODE VARCHAR(20) ) 

	------------------------------------------------------------------
	--대상 마스터 코드 조회 및 임시 저장 
	------------------------------------------------------------------
	INSERT INTO @MASTER_CODE_TBL		
	SELECT 
		UPPER(A.MASTER_CODE) AS MASTER_CODE
	FROM PKG_MASTER AS A WITH(NOLOCK)
	WHERE A.LAST_DATE >= GETDATE() AND A.SHOW_YN  = 'Y' 
		AND 
			((@TYPE = 1 AND ((ATT_CODE = 'P' AND SUBSTRING(A.MASTER_CODE, 3, 1) <>'F') OR (ATT_CODE = 'W' AND SUBSTRING(A.MASTER_CODE, 3, 1) = 'W') OR (A.BRAND_TYPE IS NOT NULL)) AND A.SIGN_CODE <> 'K') -- 패키지 / 허니문 / 수퍼클래스(국내 제외)
			OR
			(@TYPE = 2 AND ((A.SIGN_CODE = 'K' AND A.ATT_CODE <> 'G' OR SUBSTRING(A.MASTER_CODE, 0, 1) = 'K' AND SUBSTRING(A.MASTER_CODE, 3, 1) <> 'C'))) AND SUBSTRING(A.MASTER_CODE, 3, 1) NOT IN ('C', 'G')) -- 렌터카, 골프 제외 제외 
			
	------------------------------------------------------------------
	--제휴사 관리 테이블 수정및 등록 
	------------------------------------------------------------------	
	UPDATE A SET A.USE_YN = 'N' , A.EDT_DATE = GETDATE() , A.EDT_CODE = '9999999'
	FROM PKG_MASTER_AFFILIATE  A 
		LEFT JOIN @MASTER_CODE_TBL B 
			ON A.MASTER_CODE = B.MASTER_CODE 
			AND A.PROVIDER = @PROVIDER_HYUNDAICARD 
	WHERE A.PROVIDER = @PROVIDER_HYUNDAICARD 
	AND A.USE_YN = 'Y' --기존 사용중인것
	AND B.MASTER_CODE IS NULL ;

	--기존에 없는 신규추가된것.제휴사 관리 테이블에 자동 데이터 입력 
	INSERT INTO PKG_MASTER_AFFILIATE (MASTER_CODE , AFF_TYPE , NEW_DATE, NEW_CODE, USE_YN, PROVIDER)
	SELECT MASTER_CODE, @AFF_TYPE,  GETDATE() , '9999999' , 'Y' , @PROVIDER_HYUNDAICARD  
	FROM @MASTER_CODE_TBL 
	WHERE MASTER_CODE NOT IN ( SELECT MASTER_CODE FROM PKG_MASTER_AFFILIATE  WITH(NOLOCK) WHERE PROVIDER = @PROVIDER_HYUNDAICARD  );

	------------------------------------------------------------------
	-- 대상 상품 조회 ( 제휴사 관리 테이블 기준  )
	------------------------------------------------------------------
	SELECT
	 	UPPER(PM.MASTER_CODE) AS [PKG_MST_CODE], PM.MASTER_NAME AS [PKG_MST_NAME]
	FROM PKG_MASTER_AFFILIATE A 
	INNER JOIN PKG_MASTER AS PM WITH(NOLOCK)
		ON A.MASTER_CODE  = PM.MASTER_CODE 
			AND A.PROVIDER = @PROVIDER_HYUNDAICARD 
END

GO
