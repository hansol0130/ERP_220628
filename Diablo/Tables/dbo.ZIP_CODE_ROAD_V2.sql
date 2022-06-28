USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ZIP_CODE_ROAD_V2](
	[AREA_CODE] [char](5) NULL,
	[SIDO] [varchar](50) NULL,
	[GUGUN] [varchar](50) NULL,
	[DONG] [varchar](50) NULL,
	[ROAD_CODE] [varchar](20) NULL,
	[ROAD_NAME] [varchar](500) NULL,
	[IS_UNDER] [bit] NULL,
	[BD_NUM1] [varchar](10) NULL,
	[BD_NUM2] [varchar](5) NULL,
	[BD_MNG_NUM] [varchar](30) NULL,
	[PLACE_NAME] [varchar](300) NULL,
	[LAW_DONG_CODE] [varchar](10) NULL,
	[LAW_DONG] [varchar](50) NULL,
	[LAW_RI] [varchar](50) NULL,
	[GOV_DONG] [varchar](50) NULL,
	[IS_MTN] [bit] NULL,
	[BUNJI1] [varchar](10) NULL,
	[BUNJI2] [varchar](10) NULL,
	[REMARK] [varchar](300) NULL,
	[ZIP_CODE] [char](6) NULL,
	[SEQ] [char](3) NULL
) ON [PRIMARY]
GO
