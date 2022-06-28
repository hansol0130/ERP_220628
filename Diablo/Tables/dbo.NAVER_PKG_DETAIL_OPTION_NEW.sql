USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_OPTION_NEW](
	[mstCode] [varchar](20) NULL,
	[childCode] [varchar](30) NULL,
	[opt_seq] [int] NOT NULL,
	[opt_name] [nvarchar](200) NULL,
	[opt_price] [int] NULL,
	[opt_currency] [varchar](3) NULL,
	[opt_descriptions] [nvarchar](300) NULL,
	[opt_taketime] [nvarchar](120) NULL,
	[isUseGuide] [varchar](5) NOT NULL,
	[opt_absentDescriptions] [nvarchar](800) NULL,
	[OPT_COMPANION] [nvarchar](120) NULL,
	[OPT_PRICE_TXT] [varchar](120) NULL
) ON [PRIMARY]
GO
