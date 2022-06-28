USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL
■ DESCRIPTION				: 2019 네이버 패키지 상품연동 상품 조회 
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL ''

 --SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL ''

SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL 'JPP0808'
SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL 'JPP0808-190619JT|1'
GO 
SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL 'APP1016'

SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL 'APP2525'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
2019-03-18			박형만			
================================================================================================================*/ 
CREATE  PROC [dbo].[SP_PKG_MASTER_SELECT_PRODUCT_NAVER_DETAIL]
	@CODE VARCHAR(30)
AS
BEGIN

	IF CHARINDEX('-',@CODE) > 0 
	BEGIN
--DECLARE 	@CODE VARCHAR(30)
--SET @CODE = 'JPP0808-190619JT|1'

		DECLARE @MASTER_CODE VARCHAR(10)
		SET @MASTER_CODE = SUBSTRING(@CODE,1, CHARINDEX('-',@CODE)-1 ) 
		--SELECT @MASTER_CODE 

		SELECT * FROM NAVER_PKG_DETAIL WHERE mstCode = @MASTER_CODE AND childCode = @CODE order by childCode 
		SELECT * FROM NAVER_PKG_DETAIL_OPTION  WHERE mstCode = @MASTER_CODE AND childCode = @CODE  order by childCode , opt_seq 
		SELECT * FROM NAVER_PKG_DETAIL_HOTEL  WHERE mstCode = @MASTER_CODE AND  childCode = @CODE  order by childCode , [day]
		SELECT A.* , 
		--DBO.fnHTMLtoTEXT(B.SHORT_DESCRIPTION) AS SHORT_DESCRIPTION ,
		--DBO.fnHTMLtoTEXT(B.DESCRIPTION) AS DESCRIPTION , 
		B.SHORT_DESCRIPTION ,
		B.DESCRIPTION,
		B.DISPLAY_TYPE  FROM NAVER_PKG_DETAIL_SCH A WITH(NOLOCK)
			LEFT JOIN INF_MASTER B  WITH(NOLOCK) 
			ON  A.CNT_CODE = B.CNT_CODE 
		WHERE  A.mstCode = @MASTER_CODE 
		AND A.childCode = @CODE  order by A.childCode , [day],[index]

	END 
	ELSE
	BEGIN 
		SELECT * FROM NAVER_PKG_DETAIL WHERE mstCode = @CODE order by childCode 
		SELECT * FROM NAVER_PKG_DETAIL_OPTION  WHERE mstCode = @CODE  order by childCode , opt_seq 
		SELECT * FROM NAVER_PKG_DETAIL_HOTEL  WHERE mstCode = @CODE  order by childCode , [day]
			SELECT A.* , 
			--DBO.fnHTMLtoTEXT(B.SHORT_DESCRIPTION) AS SHORT_DESCRIPTION ,
			--DBO.fnHTMLtoTEXT(B.DESCRIPTION) AS DESCRIPTION , 
			B.SHORT_DESCRIPTION ,
			B.DESCRIPTION,
			B.DISPLAY_TYPE  FROM NAVER_PKG_DETAIL_SCH A WITH(NOLOCK)
			LEFT JOIN INF_MASTER B  WITH(NOLOCK) 
			ON  A.CNT_CODE = B.CNT_CODE 
		WHERE A.mstCode = @CODE  order by A.childCode , [day],[index]
		
	END 

	

END 
GO
