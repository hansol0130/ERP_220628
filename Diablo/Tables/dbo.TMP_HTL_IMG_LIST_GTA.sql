USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_HTL_IMG_LIST_GTA](
	[CITY_CODE] [varchar](5) NOT NULL,
	[HOTEL_CODE] [varchar](10) NOT NULL,
	[FILE_NAME] [varchar](50) NOT NULL,
	[IMG_HEIGHT] [varchar](5) NULL,
	[IMG_WIDTH] [varchar](5) NULL,
	[IMG_NAME] [varchar](50) NULL,
	[THUMBNAIL_LINK] [varchar](100) NULL,
	[IMG_LINK] [varchar](100) NULL,
	[MAP_LINK] [varchar](100) NULL
) ON [PRIMARY]
GO
