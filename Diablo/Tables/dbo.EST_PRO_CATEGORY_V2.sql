USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EST_PRO_CATEGORY_V2](
	[EST_CATE_LNAME] [varchar](100) NOT NULL,
	[EST_CATE_LCODE] [varchar](10) NOT NULL,
	[EST_CATE_MNAME] [varchar](100) NULL,
	[EST_CATE_MCODE] [varchar](10) NULL,
	[EST_CATE_SNAME] [varchar](100) NULL,
	[EST_CATE_SCODE] [varchar](10) NULL,
	[BRANCH_CODE] [int] NULL,
	[ATT_CODE] [varchar](100) NULL,
	[SIGN_CODE] [varchar](100) NULL,
	[NATION_CODE] [varchar](100) NULL,
	[CITY_CODE] [varchar](100) NULL,
	[TEAM_CODE] [varchar](10) NULL,
	[KEYWORD] [varchar](500) NULL
) ON [PRIMARY]
GO
