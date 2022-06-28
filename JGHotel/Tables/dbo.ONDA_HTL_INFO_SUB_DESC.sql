USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ONDA_HTL_INFO_SUB_DESC](
	[HOTEL_CODE] [nvarchar](max) NULL,
	[SUPP_CODE] [nvarchar](max) NULL,
	[DESC_TYPE] [nvarchar](max) NULL,
	[DESC_VALUE] [nvarchar](max) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [nvarchar](max) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
