USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_GTA_HOTEL_DETAIL_EN](
	[CITY_CODE] [varchar](5) NOT NULL,
	[HOTEL_CODE] [varchar](10) NOT NULL,
	[TEL_NUMBER] [varchar](20) NULL,
	[FAX_NUMBER] [varchar](20) NULL,
	[ADDRESS1] [varchar](100) NULL,
	[ADDRESS2] [varchar](100) NULL,
	[ADDRESS3] [varchar](100) NULL,
	[ADDRESS4] [varchar](100) NULL,
	[HOTEL_NAME] [varchar](100) NULL,
	[HOTEL_URL] [varchar](100) NULL,
	[NATION_CODE] [varchar](2) NULL,
	[GPS_X] [varchar](30) NULL,
	[GPS_Y] [varchar](30) NULL,
	[GRADE] [varchar](1) NULL,
	[SHORT_LOCATION] [nvarchar](200) NULL,
	[DETAIL_LOCATION] [nvarchar](400) NULL,
	[ROOM_COUNT] [int] NULL,
	[FLR_COUNT] [int] NULL,
	[ROOM_INFO] [nvarchar](max) NULL,
	[CHECK_IN_TIME] [varchar](5) NULL,
	[CHECK_OUT_TIME] [varchar](5) NULL,
	[AROUND_AIRPORT] [nvarchar](30) NULL,
	[TRANS_INFO] [nvarchar](1000) NULL,
	[HTL_INFO] [nvarchar](max) NULL,
	[FACILITY] [nvarchar](max) NULL,
	[ATTRIBUTE_INFO] [nvarchar](max) NULL,
	[LOCATION_CODE] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
