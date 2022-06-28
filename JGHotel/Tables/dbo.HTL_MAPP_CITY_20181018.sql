USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_MAPP_CITY_20181018](
	[CITY_CODE] [bigint] NOT NULL,
	[SUPP_CODE] [varchar](2) NOT NULL,
	[S_CITY_CODE] [varchar](50) NOT NULL,
	[S_CITY_NAME] [varchar](100) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL
) ON [PRIMARY]
GO
