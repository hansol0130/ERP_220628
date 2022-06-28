USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_DETAIL_PRICE_INOUT_UPDATE
■ DESCRIPTION				: 네이버 상품 포함 불포함 사항 등록
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 

EXEC SP_PKG_DETAIL_PRICE_INOUT_UPDATE 'EPP3017-190518AF' , 1  ,  'I11,I13,I20,I22'

exec SP_PKG_DETAIL_PRICE_INOUT_UPDATE @PRO_CODE='EPP4983-190422',@PRICE_SEQ=1,@IN_CODE='I1,I2',@OUT_CODE='I3,I4'

------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2019-03-07		박형만
   2019-04-22		박형만		노출되는 항목만 받도록 수정 
================================================================================================================*/ 
CREATE PROC [dbo].[SP_PKG_DETAIL_PRICE_INOUT_UPDATE]
	@PRO_CODE VARCHAR(20),
	@PRICE_SEQ INT , 

	@IN_CODE VARCHAR(1000) = null , -- I11,I23 이런식으로 선택된것만 옴 
	@OUT_CODE VARCHAR(1000) = null  -- I11,I23 이런식으로 선택된것만 옴 
AS 
BEGIN	
	
	--행사 포함/불포함 조회 
	
	--DECLARE @PRO_CODE VARCHAR(20),	@PRICE_SEQ INT ,@IN_CODE VARCHAR(1000) , @OUT_CODE  VARCHAR(1000)
	--SELECT @PRO_CODE = 'EPP3017-190521AF',@PRICE_SEQ = 1 ,@IN_CODE = 'I1,I2' ,  @OUT_CODE = 'I3,I4'

	DECLARE @TMP_IN_CODES TABLE ( IN_CODE VARCHAR(3) ) 
	INSERT INTO @TMP_IN_CODES 
	SELECT DATA FROM DBO.FN_SPLIT(@IN_CODE,',') 
	GROUP BY DATA 

	DECLARE @TMP_OUT_CODES TABLE ( OUT_CODE VARCHAR(3) ) 
	INSERT INTO @TMP_OUT_CODES 
	SELECT DATA FROM DBO.FN_SPLIT(@OUT_CODE,',') 
	GROUP BY DATA 


	---- 전체 삭제후 
	DELETE PKG_DETAIL_PRICE_INOUT 
	WHERE PRO_CODE = @PRO_CODE 
	AND PRICE_SEQ = @PRICE_SEQ

	---- 재등록 
	INSERT INTO PKG_DETAIL_PRICE_INOUT 
	( PRO_CODE , PRICE_SEQ , INOUT_CODE ,IN_YN ) 
	SELECT 
		@PRO_CODE AS PRO_CODE ,
		@PRICE_SEQ AS PRICE_SEQ ,
		A.PUB_CODE AS INOUT_CODE ,
		--A.PUB_VALUE AS INOUT_NAME, 
		B.IN_YN 		
	FROM COD_PUBLIC A  WITH(NOLOCK)
	INNER JOIN 
		(
		SELECT IN_CODE AS INOUT_CODE , 'Y' AS IN_YN 
		FROM @TMP_IN_CODES 
		UNION ALL 
		SELECT OUT_CODE AS INOUT_CODE , 'N' AS IN_YN 
		FROM @TMP_OUT_CODES 
		) B 
		ON A.PUB_CODE = B.INOUT_CODE 

	WHERE A.PUB_TYPE ='PKG.INOUT.NAVER'  
	AND A.USE_YN = 'Y'  -- 사용중인것만 

	ORDER BY A.PUB_VALUE2 ASC 

END 
GO
