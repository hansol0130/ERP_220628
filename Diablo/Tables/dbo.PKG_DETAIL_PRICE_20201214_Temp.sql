USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL_PRICE_20201214_Temp](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[PRICE_SEQ] [int] NOT NULL,
	[PRICE_NAME] [nvarchar](120) NULL,
	[SEASON] [varchar](2) NULL,
	[SCH_SEQ] [int] NULL,
	[PKG_INCLUDE] [nvarchar](max) NULL,
	[PKG_NOT_INCLUDE] [nvarchar](max) NULL,
	[ADT_PRICE] [int] NULL,
	[CHD_PRICE] [int] NULL,
	[INF_PRICE] [int] NULL,
	[SGL_PRICE] [int] NULL,
	[CUR_TYPE] [char](1) NULL,
	[EXC_RATE] [decimal](8, 2) NULL,
	[FLOATING_YN] [char](1) NULL,
	[POINT_RATE] [decimal](4, 2) NULL,
	[POINT_PRICE] [int] NULL,
	[POINT_YN] [char](1) NULL,
	[QCHARGE_TYPE] [int] NULL,
	[ADT_QCHARGE] [int] NULL,
	[CHD_QCHARGE] [int] NULL,
	[INF_QCHARGE] [int] NULL,
	[QCHARGE_DATE] [datetime] NULL,
	[ADT_TAX] [int] NULL,
	[CHD_TAX] [int] NULL,
	[INF_TAX] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
