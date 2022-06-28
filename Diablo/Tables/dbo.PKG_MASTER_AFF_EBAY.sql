USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_AFF_EBAY](
	[FLAG] [int] NULL,
	[PARTNER_GD_NO] [varchar](100) NULL,
	[PARTNER_GD_NM] [varchar](500) NULL,
	[WISH_KEYWORD] [varchar](500) NULL,
	[DISP_SITE_TYPE] [varchar](1) NULL,
	[DISP_AREA_TYPE] [varchar](2) NULL,
	[GD_DISP_START_DT] [varchar](10) NULL,
	[GD_DISP_END_DT] [varchar](10) NULL,
	[GD_DISP_PRICE_BASE_DT] [datetime] NULL,
	[GD_DISP_MIN_PRICE] [int] NULL,
	[GD_DISP_MAX_PRICE] [int] NULL,
	[GD_IMAGE_URL] [varchar](500) NULL,
	[REG_DT] [datetime] NULL,
	[CHG_DT] [datetime] NULL,
	[GD_STATUS] [varchar](1) NULL,
	[TOUR_GD_TYPE] [varchar](10) NULL,
	[DOMST_OVERSEA_TYPE] [varchar](1) NULL,
	[NATION_CD] [varchar](4) NULL,
	[NATION_NM] [varchar](100) NULL,
	[CITY_CD] [varchar](4) NULL,
	[CITY_NM] [varchar](100) NULL,
	[IMAGE_CHG_YN] [varchar](1) NULL,
	[TOUR_GUIDE_INFO] [varchar](500) NULL,
	[TOUR_STAY_DAYS] [int] NULL,
	[TOUR_DAYS] [int] NULL,
	[MORE_IMAGE_URLS] [varchar](2000) NULL,
	[MORE_IMAGE_CHG_YN] [varchar](1) NULL,
	[AFF_REMARK] [varchar](1000) NULL,
	[USE_YN] [varchar](1) NULL,
	[ROW_NUMBER] [int] NULL
) ON [PRIMARY]
GO
