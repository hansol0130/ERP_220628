USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_MOV2_RESERVE_PKG_PRICE_LIST_SELECT
■ DESCRIPTION				: 검색_상품의가격정보
■ INPUT PARAMETER			: CUS_NO, PAGE_INDEX, PAGE_SIZE
■ EXEC						: 
    -- exec SP_MOV2_RESERVE_PKG_PRICE_LIST_SELECT 'APP695-170929Z2', 1

■ MEMO						: 상품의 가격정보 가져오기
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			        DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2017-08-23		오준욱(IBSOLUTION)		최초생성
================================================================================================================*/ 
CREATE PROCEDURE [dbo].[SP_MOV2_RESERVE_PKG_PRICE_LIST_SELECT]
	@PRO_CODE		VARCHAR(20),
	@PRICE_SEQ		INT
AS
BEGIN

	SELECT TOP 1 
		A.PRO_CODE ,A.PRICE_SEQ, A.PRICE_NAME,A.SEASON,A.SCH_SEQ,
		A.PKG_INCLUDE,A.PKG_NOT_INCLUDE,
		ISNULL(B.ADT_PRICE, 0) AS ADT_PRICE,
		ISNULL(B.CHD_PRICE, 0) AS CHD_PRICE,
		ISNULL(B.INF_PRICE, 0) AS INF_PRICE,
		B.QCHARGE_TYPE,
		ISNULL(B.ADT_SALE_PRICE, 0) AS ADT_SALE_PRICE, ISNULL(B.CHD_SALE_PRICE, 0) AS CHD_SALE_PRICE, ISNULL(B.INF_SALE_PRICE, 0) AS INF_SALE_PRICE,
		ISNULL(B.ADT_SALE_QCHARGE, 0) AS ADT_SALE_QCHARGE,
		ISNULL(B.CHD_SALE_QCHARGE, 0) AS CHD_SALE_QCHARGE,
		ISNULL(B.INF_SALE_QCHARGE, 0) AS INF_SALE_QCHARGE,
		 B.SALE_QCHARGE_DATE,
		ISNULL(B.ADT_TAX, 0) AS ADT_TAX,
		ISNULL(B.CHD_TAX, 0) AS CHD_TAX,
		ISNULL(B.INF_TAX, 0) AS INF_TAX,
		A.SGL_PRICE,
		A.CUR_TYPE,A.EXC_RATE,A.FLOATING_YN,
		A.POINT_RATE,A.POINT_PRICE,A.POINT_YN,
--		DBO.XN_PRO_GET_QCHARGE_PRICE(A.PRO_CODE,'') AS QCHARGE_PRICE
		DBO.XN_PRO_DETAIL_QCHARGE_PRICE(A.PRO_CODE) AS QCHARGE_PRICE
	FROM PKG_DETAIL_PRICE A WITH(NOLOCK) 
	INNER JOIN XN_PKG_DETAIL_PRICE(@PRO_CODE, @PRICE_SEQ) B ON A.PRO_CODE = B.PRO_CODE AND A.PRICE_SEQ = B.PRICE_SEQ
	WHERE A.PRO_CODE = @PRO_CODE AND A.PRICE_SEQ = @PRICE_SEQ

END           



GO
