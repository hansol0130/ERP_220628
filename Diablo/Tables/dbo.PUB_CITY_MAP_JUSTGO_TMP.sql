USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_CITY_MAP_JUSTGO_TMP](
	[JG_CITY_CODE] [float] NULL,
	[CITY_NAME] [nvarchar](255) NULL,
	[CITY_ENAME] [nvarchar](255) NULL,
	[JG_NATION_CODE] [nvarchar](255) NULL,
	[NATION_NAME] [nvarchar](255) NULL,
	[NATION_ENAME] [nvarchar](255) NULL,
	[SORT_ORDER] [float] NULL,
	[MAIN_YN] [nvarchar](255) NULL,
	[INDEX_NAME] [nvarchar](255) NULL,
	[HOTEL_CNT] [float] NULL,
	[CENTER_LAT] [nvarchar](255) NULL,
	[CENTER_LNG] [nvarchar](255) NULL,
	[MIN_ZOOM] [float] NULL,
	[USE_YN] [nvarchar](255) NULL,
	[OLD_CODE] [nvarchar](255) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [nvarchar](255) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [nvarchar](255) NULL,
	[CITY_CODE] [nvarchar](255) NULL,
	[NATION_CODE] [nvarchar](255) NULL
) ON [PRIMARY]
GO
