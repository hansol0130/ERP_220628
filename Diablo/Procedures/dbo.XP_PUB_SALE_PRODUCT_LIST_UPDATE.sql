USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_SALE_PRODUCT_LIST_UPDATE
■ DESCRIPTION				: 할인행사 일괄 수정
■ INPUT PARAMETER			: 
	@XML NVARCHAR(MAX)		: SaleProductRQ 클래스의 SerializeXml 문자열
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_PUB_SALE_PRODUCT_LIST_UPDATE N'
<?xml version="1.0" encoding="utf-16"?>
<ArrayOfSaleProductRQ xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <SaleProductRQ>
    <SiteCode>VGL</SiteCode>
    <SaleSeq>0</SaleSeq>
    <SignCode>P</SignCode>
    <ProCode>MPP908-130423</ProCode>
    <SaleName>name : 0</SaleName>
    <Content>content : 0</Content>
    <StartDate>2013-04-24T16:09:18.690</StartDate>
    <EndDate>2013-05-01T16:09:18.690</EndDate>
    <CostPrice>10000</CostPrice>
    <OrderNum>0</OrderNum>
    <ShowYN>Y</ShowYN>
    <NewDate xsi:nil="true" />
    <NewCode>2008011</NewCode>
    <EdtDate xsi:nil="true" />
  </SaleProductRQ>
  <SaleProductRQ>
    <SiteCode>VGL</SiteCode>
    <SaleSeq>1</SaleSeq>
    <SignCode>P</SignCode>
    <ProCode>MPP980-130423</ProCode>
    <SaleName>name : 1</SaleName>
    <Content>content : 1</Content>
    <StartDate>2013-04-24T16:09:22.747</StartDate>
    <EndDate>2013-05-01T16:09:22.747</EndDate>
    <CostPrice>10000</CostPrice>
    <OrderNum>1</OrderNum>
    <ShowYN>Y</ShowYN>
    <NewDate xsi:nil="true" />
    <NewCode>2008011</NewCode>
    <EdtDate xsi:nil="true" />
  </SaleProductRQ>
  <SaleProductRQ>
    <SiteCode>VGL</SiteCode>
    <SaleSeq>2</SaleSeq>
    <SignCode>P</SignCode>
    <ProCode>EPP208-130423</ProCode>
    <SaleName>name : 2</SaleName>
    <Content>content : 2</Content>
    <StartDate>2013-04-24T16:09:22.747</StartDate>
    <EndDate>2013-05-01T16:09:22.747</EndDate>
    <CostPrice>10000</CostPrice>
    <OrderNum>2</OrderNum>
    <ShowYN>Y</ShowYN>
    <NewDate xsi:nil="true" />
    <NewCode>2008011</NewCode>
    <EdtDate xsi:nil="true" />
  </SaleProductRQ>
</ArrayOfSaleProductRQ>'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-04-24		김성호			최초생성
   2013-06-09		김성호			sale_name, content 사이즈 수정 varchar(50) -> varchar(200)
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_PUB_SALE_PRODUCT_LIST_UPDATE]
(
	@XML	NVARCHAR(MAX)
) 
AS 
BEGIN

	DECLARE @DOCHANDLE INT

	EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @XML;

	UPDATE A SET A.SALE_NAME = B.SALE_NAME, A.CONTENT = B.CONTENT, A.START_DATE = CONVERT(VARCHAR(10), B.START_DATE, 120), 
		A.END_DATE = CONVERT(VARCHAR(10), B.END_DATE, 120), A.COST_PRICE = B.COST_PRICE, A.ORDER_NUM = B.ORDER_NUM, A.EDT_CODE = B.EDT_CODE, A.EDT_DATE = GETDATE()
	FROM SALE_MASTER A
	INNER JOIN OPENXML(@DOCHANDLE, N'/ArrayOfSaleProductRQ/SaleProductRQ', 0)
	WITH
	(
		SITE_CODE	VARCHAR(3)		'./SiteCode',
		SALE_SEQ	INT				'./SaleSeq',
		--SIGN_CODE	VARCHAR(30)		'./SignCode',
		--PRO_CODE	VARCHAR(20)		'./ProCode',
		SALE_NAME	VARCHAR(200)		'./SaleName',
		CONTENT		VARCHAR(200)		'./Content',
		START_DATE	DATETIME		'./StartDate',
		END_DATE	DATETIME		'./EndDate',
		COST_PRICE	INT				'./CostPrice',
		ORDER_NUM	INT				'./OrderNum',
		--SHOW_YN		VARCHAR(10)		'./ShowYN',
		--NEW_CODE	CHAR(7)			'./NewCode',
		EDT_CODE	CHAR(7)			'./EdtCode'
	) B ON A.SITE_CODE = B.SITE_CODE AND A.SALE_SEQ = B.SALE_SEQ

	EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE

	--UPDATE A SET A.SIGN_CODE = B.SIGN_CODE, A.PRO_CODE = B.PRO_CODE, A.SALE_NAME = B.SALE_NAME, A.CONTENT = B.CONTENT, A.START_DATE = CONVERT(VARCHAR(10), B.START_DATE, 120), 
	--	A.END_DATE = CONVERT(VARCHAR(10), B.END_DATE, 120), A.COST_PRICE = B.COST_PRICE, A.ORDER_NUM = B.ORDER_NUM, A.SHOW_YN = B.SHOW_YN, A.EDT_CODE = B.EDT_CODE, A.EDT_DATE = GETDATE()

END 

GO
