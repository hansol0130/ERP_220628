USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: [SP_MOV2_PRODUCTS_BY_VR]
■ DESCRIPTION				: VR동영상 키를 사용 관련 상품 조회
■ INPUT PARAMETER			: @VR_NO
■ EXEC						: 	
    -- EXEC SP_MOV2_PRODUCTS_BY_VR 10 	 		
							  		
■ MEMO						:	VR동영상 키를 사용 관련 상품 조회
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY             		      
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-05-26	  아이비솔루션				최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_PRODUCTS_BY_VR]

	-- Add the parameters for the stored procedure here
	@VR_NO				INT	
AS
BEGIN
    	SELECT 'M' AS [FLAG], A.SIGN_CODE, A.MASTER_NAME AS [NAME], A.MASTER_CODE AS [CODE], A.PKG_COMMENT
			,A.ATT_CODE,C.*
			, (SELECT TOP 1 PKG_INCLUDE FROM PKG_MASTER_PRICE WITH(NOLOCK) WHERE MASTER_CODE = A.MASTER_CODE ORDER BY ADT_PRICE) AS [PKG_INCLUDE]
			, A.NEXT_DATE AS [DEP_DATE], A.LOW_PRICE AS [PRICE]
			, (SELECT TOP 1 KOR_NAME FROM PUB_REGION WITH(NOLOCK) WHERE C.REGION_CODE = REGION_CODE) AS REGION_NAME

			, (SELECT COUNT(*) FROM VR_CONTENT V2 WITH(NOLOCK) INNER JOIN VR_MASTER VM WITH(NOLOCK) ON V2.VR_NO = VM.VR_NO WHERE A.MASTER_CODE = V2.MASTER_CODE AND VM.VR_TYPE = 1) AS [VR_COUNT]
			, (SELECT COUNT(*) FROM PUB_EVENT_DATA A2 WITH(NOLOCK) INNER JOIN PUB_EVENT B2 WITH(NOLOCK) ON A2.EVT_SEQ = B2.EVT_SEQ WHERE B2.EVT_YN = 'Y' AND A2.SHOW_YN = 'Y' AND B2.SHOW_YN = 'Y' AND A2.MASTER_CODE = A.MASTER_CODE AND B2.END_DATE >= GETDATE()) AS [EVENT_COUNT]
			, A.TAG AS [TAG] 
			, A.BRAND_TYPE
			, A.EVENT_PRO_CODE

		FROM PKG_MASTER A WITH(NOLOCK)
		INNER JOIN INF_FILE_MASTER C WITH(NOLOCK) ON A.MAIN_FILE_CODE = C.FILE_CODE
		WHERE A.SHOW_YN ='Y'
		AND A.MASTER_CODE IN(SELECT MASTER_CODE FROM VR_CONTENT WHERE VR_NO=@VR_NO)
END
GO
