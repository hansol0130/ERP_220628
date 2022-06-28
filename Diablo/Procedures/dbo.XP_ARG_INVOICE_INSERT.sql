USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*================================================================================================================
■ USP_NAME					: XP_ARG_INVOICE_INSERT
■ DESCRIPTION				: 수배 인보이스 입력
■ INPUT PARAMETER			: 
■ OUTPUT PARAMETER			: 
■ EXEC						: 
		
	exec XP_ARG_DETAIL_INSERT 0, 1, '수배요청【오키드홀리데이/4명출발】 위해+장보고유적지/탕박온천 3일_아시아나 연합', '수배요청 수배요청 <br> ㅁㅁㅁㅁㅁㅁㅁㅁㅁ', 0, 2, 1, 0, 0, NULL, NULL, NULL, 0, '9999999'
■ MEMO						: 
------------------------------------------------------------------------------------------------------------------
■ CHANGE HISTORY                   
------------------------------------------------------------------------------------------------------------------
   DATE				AUTHOR			DESCRIPTION           
------------------------------------------------------------------------------------------------------------------
   2013-05-22		이규식			최초생성
   2014-03-21		김성호			재 생성
   2014-03-25		김성호			기본키 변경
   2014-04-07		김성호			NEW_CODE 삭제
   2014-11-25		정지용			ADT_PRICE, CHD_PRICE, INF_PRICE 삭제 및 PRICE, PERSONS, DET_SEQ_NO 추가
   2014-12-17		정지용			Price int => decimal(10, 2) 변경
================================================================================================================*/ 
CREATE PROC [dbo].[XP_ARG_INVOICE_INSERT]
	@ARG_CODE VARCHAR(12),
	@GRP_SEQ_NO INT,
	@LAND_SEQ_NO INT,
 	@CURRENCY INT,
	@EXH_RATE  MONEY,
	@AIRLINE VARCHAR(200),
	@HOTEL VARCHAR(500),
	@CONTENT NVARCHAR(MAX),
	@ACC_NAME VARCHAR(30),
	@REG_NAME VARCHAR(20),
	@REG_NUMBER VARCHAR(20),
	@HOPE_PAYDATE datetime,
	@XML XML
AS 
BEGIN

	-- ARG_INVOICE
	INSERT INTO ARG_INVOICE (ARG_CODE, GRP_SEQ_NO, LAND_SEQ_NO, CURRENCY, EXH_RATE, AIRLINE, HOTEL, CONTENT, ACC_NAME, REG_NAME, REG_NUMBER, HOPE_PAYDATE)
	VALUES (@ARG_CODE, @GRP_SEQ_NO, @LAND_SEQ_NO, @CURRENCY, @EXH_RATE, @AIRLINE, @HOTEL, @CONTENT, @ACC_NAME, @REG_NAME, @REG_NUMBER, @HOPE_PAYDATE)

	
	-- ARG_INVOICE_DETAIL
	--INSERT INTO ARG_INVOICE_DETAIL (ARG_CODE, GRP_SEQ_NO, INV_SEQ_NO, ADT_PRICE, CHD_PRICE, INF_PRICE, FOC, ETC_REMARK, PRICE, PERSONS)
	INSERT INTO ARG_INVOICE_DETAIL (ARG_CODE, GRP_SEQ_NO, INV_SEQ_NO, DET_SEQ_NO, FOC, ETC_REMARK, PRICE, PERSONS)
	SELECT
		t1.col.value('./ArrangeCode[1]', 'varchar(12)') as [ArrangeCode]
		, t1.col.value('./GroupSeqNo[1]', 'int') as [GroupSeqNo]
		, t1.col.value('./InvoiceSeqNo[1]', 'int') as [InvoiceSeqNo]
		, t1.col.value('./DetSeqNo[1]', 'int') as [DetSeqNo]
		--, t1.col.value('./AdultPrice[1]', 'int') as [AdultPrice]
		--, t1.col.value('./ChildPrice[1]', 'int') as [ChildPrice]
		--, t1.col.value('./InfantPrice[1]', 'int') as [InfantPrice]
		, t1.col.value('./Foc[1]', 'int') as [Foc]
		, t1.col.value('./Remark[1]', 'nvarchar(1000)') as [Remark]
		, t1.col.value('./Price[1]', 'decimal(10, 2)') as [Price]
		, t1.col.value('./Persons[1]', 'int') as [Persons]
	FROM @xml.nodes('/ArrayOfArrangeInvoiceDetailRQ/ArrangeInvoiceDetailRQ') as t1(col)
	
END 
/*
<ArrayOfArrangeInvoiceDetailRQ>
  <ArrangeInvoiceDetailRQ>
    <ArrangeSeqNo>1</ArrangeSeqNo>
    <GroupSeqNo>2</GroupSeqNo>
    <InvoiceSeqNo>3</InvoiceSeqNo>
    <AdultPrice>100</AdultPrice>
    <ChildPrice>200</ChildPrice>
    <InfantPrice>300</InfantPrice>
    <Foc>9</Foc>
    <NewCode>2008011</NewCode>
  </ArrangeInvoiceDetailRQ>
</ArrayOfArrangeInvoiceDetailRQ>'
*/

/*
ALTER PROC [dbo].[XP_ARG_INVOICE_INSERT]
	@ARG_SEQ_NO INT,
	@GRP_SEQ_NO INT ,
 	@CURRENCY INT,
	@EXH_RATE  MONEY,
	@AIRLINE VARCHAR(200),
	@HOTEL VARCHAR(500),
	@CONTENT NVARCHAR(MAX),
	@ACC_NAME VARCHAR(30),
	@REG_NAME VARCHAR(20),
	@REG_NUMBER VARCHAR(20),
	@NEW_CODE VARCHAR(7),
	@HOPE_PAYDATE                  datetime   
AS 
BEGIN

	INSERT INTO ARG_INVOICE
           (ARG_SEQ_NO
		   ,GRP_SEQ_NO
           ,CURRENCY
           ,EXH_RATE
		   ,AIRLINE
           ,HOTEL
           ,CONTENT
           ,ACC_NAME
           ,REG_NAME
           ,REG_NUMBER
           ,NEW_CODE
		   ,HOPE_PAYDATE)
	VALUES
           (@ARG_SEQ_NO
		   ,@GRP_SEQ_NO
           ,@CURRENCY
           ,@EXH_RATE
		   ,@AIRLINE
           ,@HOTEL
           ,@CONTENT
           ,@ACC_NAME
           ,@REG_NAME
           ,@REG_NUMBER
           ,@NEW_CODE
		   ,@HOPE_PAYDATE)
END 
*/
GO
