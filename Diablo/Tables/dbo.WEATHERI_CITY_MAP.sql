USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WEATHERI_CITY_MAP](
	[W_CITY_CODE] [varchar](10) NULL,
	[W_CITY_ENG_NAME] [varchar](255) NULL,
	[W_CITY_KOR_NAME] [varchar](255) NULL,
	[W_NATION_CODE] [varchar](2) NULL,
	[W_NATION_KOR_NAME] [varchar](255) NULL,
	[W_NATION_ENG_NAME] [varchar](255) NULL,
	[W_REGION_KOR_NAME] [varchar](255) NULL,
	[W_REGION_ENG_NAME] [varchar](255) NULL,
	[CITY_CODE] [varchar](3) NULL,
	[NATION_CODE] [varchar](2) NULL,
	[REMARK] [varchar](255) NULL
) ON [PRIMARY]
GO
