USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_SALE_PRODUCT_LIST_DELETE
■ DESCRIPTION				: 할인행사 일괄 삭제
■ INPUT PARAMETER			: 
	@XML NVARCHAR(MAX)		: SaleProductRQ 클래스의 SerializeXml 문자열
■ OUTPUT PARAMETER			: 
■ EXEC						: 
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-24		김성호			최초생성   
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_PUB_SALE_PRODUCT_LIST_DELETE]
(
	@XML	NVARCHAR(MAX)
) 
AS 
BEGIN

	DECLARE @DOCHANDLE INT

	EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @XML;

	UPDATE A SET A.SHOW_YN = B.SHOW_YN, A.EDT_CODE = B.EDT_CODE, A.EDT_DATE = GETDATE()
	FROM SALE_MASTER A
	INNER JOIN OPENXML(@DOCHANDLE, N'/ArrayOfSaleProductRQ/SaleProductRQ', 0)
	WITH
	(
		SITE_CODE	VARCHAR(3)		'./SiteCode',
		SALE_SEQ	INT				'./SaleSeq',
		SHOW_YN		VARCHAR(10)		'./ShowYN',
		EDT_CODE	CHAR(7)			'./EdtCode'
	) B ON A.SITE_CODE = B.SITE_CODE AND A.SALE_SEQ = B.SALE_SEQ

	EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE

END 
GO
