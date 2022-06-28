USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*================================================================================================================
■ USP_NAME					: XP_PUB_MENU_ORDER
■ DESCRIPTION				: 메뉴 순번 수정
■ INPUT PARAMETER			: 
	@XML NVARCHAR(MAX)		: SaleProductRQ 클래스의 SerializeXml 문자열
■ OUTPUT PARAMETER			: 
■ EXEC						: 

	EXEC XP_PUB_MENU_ORDER N'
<ArrayOfVgtMenuRQ xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <VgtMenuRQ>
    <SiteCode>VGT</SiteCode>
    <MenuCode>101</MenuCode>
    <OrderType>지역별</OrderType>
    <OrderNumber>0</OrderNumber>
    <IsUse>false</IsUse>
    <NewCode>2008011</NewCode>
    <EdtCode>2008011</EdtCode>
  </VgtMenuRQ>
  <VgtMenuRQ>
    <SiteCode>VGT</SiteCode>
    <MenuCode>102</MenuCode>
    <OrderType>지역별</OrderType>
    <OrderNumber>1</OrderNumber>
    <IsUse>false</IsUse>
    <NewCode>2008011</NewCode>
    <EdtCode>2008011</EdtCode>
  </VgtMenuRQ>
  <VgtMenuRQ>
    <SiteCode>VGT</SiteCode>
    <MenuCode>103</MenuCode>
    <OrderType>지역별</OrderType>
    <OrderNumber>2</OrderNumber>
    <IsUse>false</IsUse>
    <NewCode>2008011</NewCode>
    <EdtCode>2008011</EdtCode>
  </VgtMenuRQ>
</ArrayOfVgtMenuRQ>'

■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-03		김성호			최초생성
   2013-06-10		김성호			WITH(NOLOCK) 추가
================================================================================================================*/ 
 CREATE PROCEDURE [dbo].[XP_PUB_MENU_ORDER]
(
	@XML	NVARCHAR(MAX)
) 
AS 
BEGIN

	DECLARE @DOCHANDLE INT

	EXEC SP_XML_PREPAREDOCUMENT @DOCHANDLE OUTPUT, @XML;

	UPDATE A SET A.ORDER_NUM = B.ORDER_NUM
	FROM MNU_MASTER A WITH(NOLOCK)
	INNER JOIN OPENXML(@DOCHANDLE, N'/ArrayOfVgtMenuRQ/VgtMenuRQ', 0)
	WITH
	(
		SITE_CODE	VARCHAR(3)		'./SiteCode',
		MENU_CODE	VARCHAR(20)		'./MenuCode',
		ORDER_NUM	INT				'./OrderNumber'
	) B ON A.SITE_CODE = B.SITE_CODE AND A.MENU_CODE = B.MENU_CODE

	EXEC SP_XML_REMOVEDOCUMENT @DOCHANDLE
END 

GO
