USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_INFO_MAST_HOTEL_OF](
	[HOTEL_CODE] [varchar](500) NOT NULL,
	[NAME] [varchar](200) NULL,
	[ENG_NAME] [varchar](200) NULL,
	[CITY_CODE] [bigint] NULL,
	[CITY_NAME] [varchar](100) NULL,
	[ADDRESS] [varchar](200) NULL,
	[PHONE] [varchar](50) NULL,
	[FAX] [varchar](50) NULL,
	[LATITUDE] [varchar](50) NULL,
	[LONGITUDE] [varchar](50) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](100) NULL
) ON [PRIMARY]
GO
