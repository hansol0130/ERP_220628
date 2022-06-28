USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_IDX_SEARCH](
	[INT_DOM] [varchar](3) NOT NULL,
	[HOTEL_CODE] [int] NOT NULL,
	[NAME] [varchar](500) NULL,
	[ENG_NAME] [varchar](500) NULL,
	[STAR_RATING] [varchar](30) NULL,
	[CITY_CODE] [varchar](30) NULL,
	[CITY_NAME] [varchar](100) NULL,
	[AREA_NAME] [varchar](200) NULL,
	[ADDRESS] [varchar](200) NULL,
	[RV_POINT] [decimal](16, 2) NULL,
	[TYPE_CODE] [varchar](10) NULL,
	[TYPE_CODE_NAME] [varchar](300) NULL,
	[SALE_AMT] [decimal](18, 0) NULL,
	[MAIN_IMG] [varchar](500) NULL,
	[USE_YN] [varchar](1) NULL,
	[INDEX_NAME] [varchar](899) NULL,
	[SORT_ORDER] [int] NULL
) ON [PRIMARY]
GO
