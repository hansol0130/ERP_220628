USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*================================================================================================================
■ USP_NAME					: SP_CTI_ERP_GOODS_MASTER_SELECT
■ DESCRIPTION				: ERP 상품마스터 검색
■ INPUT PARAMETER			: 
	@CUS_NO					: 고객ID
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	exec SP_CTI_ERP_GOODS_MASTER_SELECT 'A', 'P', '%%'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-10-21		곽병삼			최초생성
================================================================================================================*/ 
CREATE PROCEDURE [cti].[SP_CTI_ERP_GOODS_MASTER_SELECT]
--DECLARE
	@SIGN			VARCHAR(1),
	@ATT_CODE		VARCHAR(1),
	@SEARCH_KEYWORD	VARCHAR(200)

AS

SET NOCOUNT ON

	SELECT
		PKG.MASTER_CODE,
		PKG.MASTER_NAME
	FROM Diablo.dbo.PKG_MASTER PKG WITH(NOLOCK)
	WHERE PKG.MASTER_CODE IN (SELECT MASTER_CODE FROM Diablo.dbo.PKG_ATTRIBUTE WITH(NOLOCK) WHERE ATT_CODE = @ATT_CODE)
	AND PKG.SIGN_CODE = @SIGN
	AND PKG.ATT_CODE = @ATT_CODE
	AND ISNULL(PKG.TOUR_JOURNEY,'') LIKE ('%' + ISNULL(@SEARCH_KEYWORD,'') + '%')
	AND (PKG.SECTION_YN = 'Y' OR PKG.NEXT_DATE >= CONVERT(VARCHAR(10),GETDATE(),120))
	AND (PKG.SECTION_YN = 'Y' OR PKG.SHOW_YN = 'Y')
	AND ((SELECT COUNT(A.PRO_CODE) AS CNT
		FROM Diablo.dbo.PKG_DETAIL A WITH(NOLOCK), Diablo.dbo.RES_MASTER_DAMO B WITH(NOLOCK), Diablo.dbo.RES_CUSTOMER_DAMO C WITH(NOLOCK)
		WHERE A.MASTER_CODE = PKG.MASTER_CODE
		AND A.PRO_CODE = B.PRO_CODE
		AND B.RES_STATE < = 7
		AND B.RES_CODE = C.RES_CODE
		AND C.RES_STATE IN (0, 3)) > 0
	OR (SELECT
			COUNT(*) AS CNT
		FROM Diablo.dbo.PKG_DETAIL DETAIL WITH(NOLOCK)
		WHERE DETAIL.MASTER_CODE = PKG.MASTER_CODE
		AND SALE_TYPE IN ('2','3')) > 0)
	ORDER BY PKG.REGION_ORDER;

SET NOCOUNT OFF
GO
