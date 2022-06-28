USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_INFO_SUB_HOTEL_20181016](
	[HOTEL_CODE] [varchar](50) NOT NULL,
	[SUPP_CODE] [varchar](2) NOT NULL,
	[NAME] [nvarchar](400) NULL,
	[ENG_NAME] [nvarchar](400) NULL,
	[CITY_CODE] [varchar](50) NULL,
	[CITY_NAME] [varchar](100) NULL,
	[NATION_CODE] [varchar](50) NULL,
	[NATION_NAME] [varchar](100) NULL,
	[AREA_CODE] [varchar](50) NULL,
	[AREA_NAME] [varchar](100) NULL,
	[LANDMARK_NAME] [varchar](200) NULL,
	[RESV_TIP] [varchar](1000) NULL,
	[STAR_RATING] [varchar](10) NULL,
	[CHECK_IN_TIME] [varchar](30) NULL,
	[CHECK_OUT_TIME] [varchar](30) NULL,
	[ADDRESS] [varchar](300) NULL,
	[PHONE] [varchar](200) NULL,
	[FAX] [varchar](200) NULL,
	[ROOMS] [varchar](50) NULL,
	[HOME_PAGE] [varchar](500) NULL,
	[MAIN_IMG] [varchar](200) NULL,
	[LATITUDE] [varchar](30) NULL,
	[LONGITUDE] [varchar](30) NULL,
	[RECOM_YN] [varchar](1) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL
) ON [PRIMARY]
GO
