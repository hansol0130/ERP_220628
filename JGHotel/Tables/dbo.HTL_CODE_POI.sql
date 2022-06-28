USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_CODE_POI](
	[POI_CODE] [bigint] NOT NULL,
	[POI_NAME] [varchar](255) NULL,
	[POI_ENAME] [varchar](255) NULL,
	[SUB_CLASS] [varchar](255) NULL,
	[CITY_CODE] [bigint] NULL,
	[LATITUDE] [float] NULL,
	[LONGITUDE] [float] NULL,
	[USE_YN] [varchar](1) NULL
) ON [PRIMARY]
GO
