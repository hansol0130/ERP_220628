USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_PRICE_INOUT_SELECT
■ DESCRIPTION				: 네이버 상품 포함 불포함 사항 조회  
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 

EXEC SP_PKG_DETAIL_PRICE_INOUT_UPDATE 'EPP3017-190518AF' , 1  ,  'I11,I13,I20,I22,I23'
EXEC SP_PKG_DETAIL_PRICE_INOUT_SELECT 'EPP3017-190518AF' , 1 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-03-07		박형만
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_DETAIL_PRICE_INOUT_SELECT]
	@PRO_CODE VARCHAR(20),
	@PRICE_SEQ INT
AS 
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--행사 포함/불포함 조회 
	--DECLARE @PRO_CODE VARCHAR(20),	@PRICE_SEQ INT 
	--SELECT @PRO_CODE = 'APP111-12312131',@PRICE_SEQ = 1 

	SELECT 
		B.PRO_CODE AS PRO_CODE ,
		B.PRICE_SEQ AS PRICE_SEQ ,
		A.PUB_CODE AS INOUT_CODE ,
		A.PUB_VALUE AS INOUT_NAME, 
		CASE WHEN A.PUB_CODE = B.INOUT_CODE AND B.IN_YN = 'Y' THEN 'Y' ELSE 'N' END AS IN_YN 
	 
	FROM COD_PUBLIC A  WITH(NOLOCK)
		LEFT JOIN PKG_DETAIL_PRICE_INOUT B  WITH(NOLOCK)
			ON A.PUB_CODE = B.INOUT_CODE 
			AND B.PRO_CODE = @PRO_CODE 
			AND B.PRICE_SEQ = @PRICE_SEQ 
	WHERE A.PUB_TYPE ='PKG.INOUT.NAVER'  
	AND A.USE_YN = 'Y' 
	ORDER BY A.PUB_VALUE2 ASC 


END 


GO
