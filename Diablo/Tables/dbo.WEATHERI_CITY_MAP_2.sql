USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WEATHERI_CITY_MAP_2](
	[W_CITY_CODE] [varchar](10) NULL,
	[W_CITY_ENG_NAME] [varchar](255) NULL,
	[W_CITY_KOR_NAME] [varchar](255) NULL,
	[W_NATION_CODE] [varchar](3) NULL,
	[W_NATION_KOR_NAME] [varchar](255) NULL,
	[W_NATION_ENG_NAME] [varchar](255) NULL,
	[W_REGION_KOR_NAME] [varchar](255) NULL,
	[W_REGION_ENG_NAME] [varchar](255) NULL,
	[LATITUDE] [varchar](20) NULL,
	[LONGITUDE] [varchar](20) NULL,
	[UTC] [varchar](6) NULL,
	[SUMMER_TIME_START] [datetime] NULL,
	[SUMMER_TIME_END] [datetime] NULL,
	[CITY_CODE] [varchar](3) NULL,
	[NATION_CODE] [varchar](2) NULL,
	[REMARK] [varchar](255) NULL,
	[W_CITY_CODE_OLD] [varchar](10) NULL
) ON [PRIMARY]
GO
