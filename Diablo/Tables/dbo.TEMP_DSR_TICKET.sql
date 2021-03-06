USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMP_DSR_TICKET](
	[TICKET] [varchar](10) NOT NULL,
	[TICKET_STATUS] [int] NULL,
	[FARE_TYPE] [int] NULL,
	[START_DATE] [datetime] NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[AIRLINE_NUM] [varchar](3) NULL,
	[AIRLINE_CODE] [varchar](2) NULL,
	[CONJ_YN] [varchar](1) NULL,
	[ROUTING] [varchar](30) NULL,
	[FARE] [float] NULL,
	[DISCOUNT] [float] NULL,
	[COMM_RATE] [varchar](3) NULL,
	[COMM_PRICE] [float] NULL,
	[NET_PRICE] [float] NULL,
	[TAX_PRICE] [float] NULL,
	[FOP] [int] NULL,
	[CASH_PRICE] [float] NULL,
	[CARD_PRICE] [float] NULL,
	[CARD_TYPE] [varchar](2) NULL,
	[CARD_NUM] [varchar](16) NULL,
	[EXPIRE_DATE] [varchar](4) NULL,
	[CARD_AUTH] [varchar](8) NULL,
	[INSTALLMENT] [varchar](3) NULL,
	[PKG_PCC] [varchar](4) NULL,
	[TKT_PCC] [varchar](4) NULL,
	[ITEM_NO] [varchar](6) NULL,
	[PNR] [varchar](9) NULL,
	[PAX_NAME] [varchar](40) NULL,
	[ISSUE_DATE] [datetime] NULL,
	[PRINTER] [varchar](4) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[ISSUE_CODE] [dbo].[EMP_CODE] NULL,
	[SALE_CODE] [dbo].[EMP_CODE] NULL,
	[REGION_CODE] [dbo].[REGION_CODE] NULL,
	[TICKET_COUNT] [int] NULL,
	[DSR_SEQ] [int] NULL,
	[TICKET_TYPE] [int] NULL,
	[PRO_TYPE] [int] NULL,
	[REQUEST_CODE] [varchar](20) NULL,
	[RES_SEQ_NO] [int] NULL,
	[COMPANY] [int] NULL,
	[GDS] [int] NULL,
	[PARENT_TICKET] [varchar](10) NULL
) ON [PRIMARY]
GO
