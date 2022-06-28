USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOOKINGCOM_HTL_CODE_SUB_CITY](
	[CITY_CODE] [nvarchar](100) NOT NULL,
	[CITY_CODE2] [nvarchar](100) NOT NULL,
	[SUPP_CODE] [nvarchar](2) NOT NULL,
	[CITY_NAME] [nvarchar](200) NULL,
	[CITY_ENAME] [nvarchar](200) NULL,
	[NATION_CODE] [nvarchar](50) NULL,
	[NATION_CODE2] [nvarchar](50) NULL,
	[NATION_NAME] [nvarchar](100) NULL,
	[USE_YN] [nvarchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [nvarchar](50) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [nvarchar](50) NULL,
	[STATE_CODE] [nvarchar](50) NULL,
	[HOTEL_CNT] [int] NULL
) ON [PRIMARY]
GO
