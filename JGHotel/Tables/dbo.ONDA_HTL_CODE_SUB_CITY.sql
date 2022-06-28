USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ONDA_HTL_CODE_SUB_CITY](
	[CITY_CODE] [nvarchar](max) NULL,
	[CITY_CODE2] [nvarchar](max) NULL,
	[SUPP_CODE] [nvarchar](max) NULL,
	[CITY_NAME] [nvarchar](max) NULL,
	[CITY_ENAME] [nvarchar](max) NULL,
	[NATION_CODE] [nvarchar](max) NULL,
	[NATION_CODE2] [nvarchar](max) NULL,
	[NATION_NAME] [nvarchar](max) NULL,
	[USE_YN] [nvarchar](max) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [nvarchar](max) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [nvarchar](max) NULL,
	[STATE_CODE] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
