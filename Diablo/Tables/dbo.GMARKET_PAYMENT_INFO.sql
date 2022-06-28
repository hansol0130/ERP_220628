USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GMARKET_PAYMENT_INFO](
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[ORDER_NO] [varchar](10) NULL,
	[TOT_PRICE] [int] NULL,
	[G_DISC_PRICE] [int] NULL,
	[P_DISC_PRICE] [int] NULL,
	[ORG_PRICE] [int] NULL,
	[PAY_METH] [varchar](10) NULL,
	[ONLINE_PAY_DT] [datetime] NULL,
	[CANCEL_ABLE_DT] [datetime] NULL,
	[REQ_YN] [char](1) NULL,
	[COMP_YN] [char](1) NULL,
	[CANCEL_YN] [char](1) NULL,
	[REQ_DATE] [datetime] NULL,
	[COMP_DATE] [datetime] NULL,
	[CANCEL_DATE] [datetime] NULL,
	[REMARK] [varchar](500) NULL
) ON [PRIMARY]
GO
