USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ONDA_HTL_INFO_SUB_IMAGE](
	[HOTEL_CODE] [varchar](50) NULL,
	[SUPP_CODE] [varchar](2) NULL,
	[IMG_TYPE] [varchar](5) NULL,
	[IMG_TITLE] [varchar](200) NULL,
	[IMG_THUMB] [varchar](400) NULL,
	[IMG_URL] [varchar](400) NULL,
	[MAIN_YN] [varchar](1) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL
) ON [PRIMARY]
GO
