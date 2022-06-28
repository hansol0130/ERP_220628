USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_EVENT_MAST](
	[EVENT_NO] [int] IDENTITY(1,1) NOT NULL,
	[HOTEL_CODE] [int] NULL,
	[NAME] [varchar](200) NULL,
	[ENG_NAME] [varchar](200) NULL,
	[MCPN_CODE] [varchar](20) NULL,
	[SUPP_CODE] [varchar](4) NULL,
	[SUPP_NAME] [varchar](10) NULL,
	[CITY_CODE] [int] NULL,
	[CITY_NAME] [varchar](100) NULL,
	[AREA_CODE] [int] NULL,
	[AREA_NAME] [varchar](200) NULL,
	[NATION_CODE] [varchar](2) NULL,
	[NATION_NAME] [varchar](100) NULL,
	[NATION_ENAME] [varchar](100) NULL,
	[TITLE] [varchar](300) NULL,
	[DATE_FROM] [datetime] NULL,
	[DATE_TO] [datetime] NULL,
	[APP_DAY] [varchar](20) NULL,
	[RECOM_DESC] [varchar](300) NULL,
	[EVENT_DESC] [varchar](max) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](50) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](50) NULL,
 CONSTRAINT [PK_HTL_EVENT_MAST] PRIMARY KEY CLUSTERED 
(
	[EVENT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO