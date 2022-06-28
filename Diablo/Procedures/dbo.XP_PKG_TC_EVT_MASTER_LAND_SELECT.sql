USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
■ Server					: 211.115.202.230
■ Database					: DIABLO
■ USP_Name					: XP_PKG_TC_EVT_MASTER_LAND_SELECT
■ Description				: 
■ Input Parameter			:                  
	@MASTER_CODE	VARCHAR(10)
■ Output Parameter			:                  
■ Output Value				:                 
■ Exec						:  
	exec XP_PKG_TC_EVT_MASTER_LAND_SELECT 'CPP306'
■ Author					:  
■ Date						: 
■ Memo						: 상품마스터화면/ 랜드사 조회
---------------------------------------------------------------------------------------------------
■ Change History                   
---------------------------------------------------------------------------------------------------
   Date				Author			Description           
---------------------------------------------------------------------------------------------------
  2013-04-25		오인규 			최초생성
  2014-01-16		김성호			쿼리수정
-------------------------------------------------------------------------------------------------*/ 
CREATE PROCEDURE [dbo].[XP_PKG_TC_EVT_MASTER_LAND_SELECT]
(   
	@MASTER_CODE	VARCHAR(10)
)
AS

BEGIN
	SELECT TOP 10  A.PRO_CODE
		, CONVERT(VARCHAR(10), DEP_DATE,120) AS DEP_DATE 
		, [dbo].[FN_PRO_GET_RES_COUNT](A.PRO_CODE) AS RESCOUNT
		--, (SELECT COUNT(C.RES_CODE) FROM dbo.Res_master_damo C  INNER JOIN dbo.RES_CUSTOMER_damo D ON C.RES_CODE = D.RES_CODE
		--	WHERE C.PRO_CODE  = A.PRO_CODE) AS RESCOUNT 
		, CASE WHEN A.TC_NAME = '' THEN '없음' ELSE ISNULL(A.TC_NAME, '없음') END AS TC_NAME
		, TOTAL_VALUATION AS PKG_POINT
		, ISNULL(B.OTR_STATE,0) AS OTR_STATE
	FROM dbo.PKG_DETAIL A WITH(NOLOCK)
	LEFT OUTER JOIN OTR_MASTER B WITH(NOLOCK) ON A.PRO_CODE =B.PRO_CODE
	WHERE A.MASTER_CODE = @MASTER_CODE AND ISNULL(B.OTR_STATE, 0) = '3'
	ORDER BY A.DEP_DATE DESC
END

GO
