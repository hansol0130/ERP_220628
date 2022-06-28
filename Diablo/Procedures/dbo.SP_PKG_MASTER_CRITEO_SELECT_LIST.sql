USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_CRITEO_SELECT_LIST
■ DESCRIPTION				: CRITEO 수집을 위한 마스터 조회 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	EXEC SP_PKG_MASTER_CRITEO_SELECT_LIST
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2014-09-24			정지용			CRITEO 수집을 위한 마스터 조회 
2020-03-06			김영민			aff변경
2021-01-18			홍종우			리뉴얼 후 변경 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_MASTER_CRITEO_SELECT_LIST]
	@IS_MOBILE VARCHAR(1) = '' 
AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH LIST AS
	(
		SELECT 
			A.MASTER_CODE
		FROM PKG_MASTER A WITH(NOLOCK)
		WHERE A.SHOW_YN = 'Y' AND A.LAST_DATE >= GETDATE()
	)
	SELECT 
		A.MASTER_CODE, A.MASTER_NAME, A.LOW_PRICE, A.PKG_COMMENT,
		CASE 
			WHEN B.FILE_NAME_S = '' THEN ''
			WHEN B.FILE_NAME_M = '' THEN 'http://contents.verygoodtour.com/content/' + B.REGION_CODE + '/' + B.NATION_CODE + '/' + B.STATE_CODE + '/' + B.CITY_CODE + '/image/' + B.FILE_NAME_S
			ELSE 'http://contents.verygoodtour.com/content/' + B.REGION_CODE + '/' + B.NATION_CODE + '/' + B.STATE_CODE + '/' + B.CITY_CODE + '/image/' + B.FILE_NAME_M
		END AS IMAGE_URL, C.KOR_NAME AS CATEGORY_NAME,
		CASE 
			WHEN @IS_MOBILE = 'Y' THEN 
			'http://m.verygoodtour.com/Product/PackageMaster?MasterCode=' + A.MASTER_CODE + '&utm_source=criteo'
		ELSE
			'http://www.verygoodtour.com/Product/Package/PackageMaster?MasterCode=' + A.MASTER_CODE + '&utm_source=criteo'
		END AS PRODUCT_URL		

	FROM LIST Z
	INNER JOIN PKG_MASTER A WITH(NOLOCK) ON Z.MASTER_CODE = A.MASTER_CODE
	LEFT JOIN INF_FILE_MASTER B WITH(NOLOCK) ON A.MAIN_FILE_CODE = B.FILE_CODE
	LEFT JOIN PUB_REGION C WITH(NOLOCK) ON A.SIGN_CODE = C.SIGN

END

GO
