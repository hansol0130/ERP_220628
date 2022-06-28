USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WEATHERI_CITY_MAP_EXT](
	[W_CITY_CODE] [varchar](10) NULL,
	[W_LAT] [varchar](255) NULL,
	[W_LNG] [varchar](255) NULL,
	[W_CITY_ENG_NAME] [varchar](255) NULL,
	[W_CITY_KOR_NAME] [varchar](255) NULL,
	[W_NATION_CODE] [varchar](10) NULL,
	[W_NATION_KOR_NAME] [varchar](255) NULL,
	[W_NATION_ENG_NAME] [varchar](255) NULL,
	[W_REGION_CODE] [varchar](50) NULL,
	[W_REGION_KOR_NAME] [varchar](255) NULL,
	[W_REGION_ENG_NAME] [varchar](255) NULL,
	[W_HOUR_DIFF] [varchar](50) NULL,
	[CITY_CODE] [varchar](50) NULL
) ON [PRIMARY]
GO
