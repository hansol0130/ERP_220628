USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_SCH_NEW](
	[mstCode] [varchar](20) NULL,
	[childCode] [varchar](30) NULL,
	[day] [int] NULL,
	[index] [bigint] NULL,
	[title] [nvarchar](500) NULL,
	[spotPoiID] [varchar](30) NULL,
	[imageUrl] [varchar](500) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[PRICE_SEQ] [int] NULL,
	[SCH_SEQ] [int] NULL,
	[DAY_NUMBER] [int] NULL,
	[CITY_NAME] [nvarchar](200) NULL,
	[CNT_CODE] [int] NULL,
	[CNT_INFO] [nvarchar](max) NULL,
	[CITY_CODE] [varchar](3) NULL,
	[N_CITY_CODE] [varchar](3) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
