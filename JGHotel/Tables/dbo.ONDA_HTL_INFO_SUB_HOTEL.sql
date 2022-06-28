USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ONDA_HTL_INFO_SUB_HOTEL](
	[HOTEL_CODE] [nvarchar](max) NULL,
	[SUPP_CODE] [nvarchar](max) NULL,
	[NAME] [nvarchar](max) NULL,
	[ENG_NAME] [nvarchar](max) NULL,
	[CITY_CODE] [nvarchar](max) NULL,
	[CITY_NAME] [nvarchar](max) NULL,
	[NATION_CODE] [nvarchar](max) NULL,
	[NATION_NAME] [nvarchar](max) NULL,
	[AREA_CODE] [nvarchar](max) NULL,
	[AREA_NAME] [nvarchar](max) NULL,
	[LANDMARK_NAME] [nvarchar](max) NULL,
	[RESV_TIP] [nvarchar](max) NULL,
	[STAR_RATING] [nvarchar](max) NULL,
	[CHECK_IN_TIME] [nvarchar](max) NULL,
	[CHECK_OUT_TIME] [nvarchar](max) NULL,
	[ADDRESS] [nvarchar](max) NULL,
	[PHONE] [nvarchar](max) NULL,
	[FAX] [nvarchar](max) NULL,
	[ROOMS] [nvarchar](max) NULL,
	[HOME_PAGE] [nvarchar](max) NULL,
	[MAIN_IMG] [nvarchar](max) NULL,
	[LATITUDE] [nvarchar](max) NULL,
	[LONGITUDE] [nvarchar](max) NULL,
	[RECOM_YN] [nvarchar](max) NULL,
	[USE_YN] [nvarchar](max) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [nvarchar](max) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
