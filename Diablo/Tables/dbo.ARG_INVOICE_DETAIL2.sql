USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARG_INVOICE_DETAIL2](
	[ARG_CODE] [varchar](12) NOT NULL,
	[GRP_SEQ_NO] [int] NOT NULL,
	[INV_SEQ_NO] [int] NOT NULL,
	[ADT_PRICE] [int] NULL,
	[CHD_PRICE] [int] NULL,
	[INF_PRICE] [int] NULL,
	[FOC] [int] NULL,
	[ETC_REMARK] [nvarchar](1000) NULL
) ON [PRIMARY]
GO
