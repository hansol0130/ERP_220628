USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_IDX_CITY](
	[NATION_CODE] [varchar](2) NULL,
	[NATION_NAME] [varchar](300) NULL,
	[NATION_ENAME] [varchar](300) NULL,
	[CITY_CODE] [bigint] NULL,
	[CITY_NAME] [varchar](300) NULL,
	[CITY_ENAME] [varchar](300) NULL,
	[AREA_CODE] [bigint] NULL,
	[AREA_NAME] [varchar](300) NULL,
	[AREA_ENAME] [varchar](300) NULL,
	[HOTEL_CODE] [int] NULL,
	[HOTEL_NAME] [varchar](300) NULL,
	[HOTEL_ENAME] [varchar](300) NULL,
	[INDEX_NAME] [varchar](500) NULL,
	[SORT] [int] NULL,
	[HOTEL_CNT] [int] NULL,
	[ITEM_TYPE] [varchar](1) NULL,
	[USE_YN] [varchar](1) NULL
) ON [PRIMARY]
GO
