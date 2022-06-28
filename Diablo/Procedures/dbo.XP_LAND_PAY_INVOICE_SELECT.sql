USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_LAND_PAY_INVOICE_SELECT
■ DESCRIPTION				: 랜드사 지상비 인보이스검색
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
	exec XP_LAND_PAY_INVOICE_SELECT @PRO_CODE=N'APP199-141229',@LAND_SEQ_NO=N'1,2'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2014-12-18		정지용			최초생성    
================================================================================================================*/ 

create PROCEDURE [dbo].[XP_LAND_PAY_INVOICE_SELECT] 
( 
    @PRO_CODE		VARCHAR(20),
	@LAND_SEQ_NO	VARCHAR(100)
) 
AS 
BEGIN 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT A.*, B.CUR_TYPE FROM (
	SELECT 
		A.PRO_CODE,
		A.AGT_CODE,
		C.LAND_SEQ_NO,
		D.*, E.TITLE
	FROM ARG_MASTER A WITH(NOLOCK)
	INNER JOIN ARG_DETAIL B ON A.ARG_CODE = B.ARG_CODE
	INNER JOIN ARG_INVOICE C ON B.ARG_CODE = C.ARG_CODE AND B.GRP_SEQ_NO = C.GRP_SEQ_NO
	INNER JOIN ARG_INVOICE_DETAIL D WITH(NOLOCK) ON C.ARG_CODE = D.ARG_CODE AND C.GRP_SEQ_NO = D.GRP_SEQ_NO
	INNER JOIN ARG_INVOICE_ITEM E WITH(NOLOCK) ON D.INV_SEQ_NO = E.INV_SEQ_NO
	WHERE 
		A.PRO_CODE = @PRO_CODE AND C.LAND_SEQ_NO IN (SELECT DATA FROM DBO.FN_SPLIT(@LAND_SEQ_NO, ',')) AND B.ARG_STATUS <> 7 
		AND A.AGT_CODE IN ( SELECT A.AGT_CODE FROM SET_LAND_AGENT A WITH(NOLOCK) WHERE A.PRO_CODE = @PRO_CODE
		AND LAND_SEQ_NO IN (SELECT DATA FROM DBO.FN_SPLIT(@LAND_SEQ_NO, ',')))
) A INNER JOIN SET_LAND_AGENT B WITH(NOLOCK) ON A.PRO_CODE = B.PRO_CODE AND A.AGT_CODE = B.AGT_CODE AND A.LAND_SEQ_NO = B.LAND_SEQ_NO

END 
GO
