USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_HOTEL_NEW](
	[mstCode] [varchar](20) NULL,
	[childCode] [varchar](30) NULL,
	[dayTotal] [int] NULL,
	[day] [int] NULL,
	[eat_breakfast] [varchar](10) NOT NULL,
	[eat_breakfastText] [varchar](500) NULL,
	[eat_lunch] [varchar](10) NOT NULL,
	[eat_lunchText] [varchar](500) NULL,
	[eat_dinner] [varchar](10) NOT NULL,
	[eat_dinnerText] [varchar](500) NULL,
	[stay_hotelPoiID] [varchar](500) NOT NULL,
	[stay_text] [nvarchar](1000) NULL,
	[HTL_MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[HOTEL_NAME] [nvarchar](500) NULL
) ON [PRIMARY]
GO
