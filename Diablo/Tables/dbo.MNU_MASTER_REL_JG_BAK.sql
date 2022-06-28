USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MNU_MASTER_REL_JG_BAK](
	[SITE_CODE] [char](3) NOT NULL,
	[MENU_CODE] [varchar](20) NOT NULL,
	[PARENT_CODE] [varchar](20) NULL,
	[MENU_NAME] [varchar](100) NULL,
	[REGION_CODE] [varchar](30) NULL,
	[NATION_CODE] [varchar](30) NULL,
	[CITY_CODE] [varchar](30) NULL,
	[ATT_CODE] [varchar](50) NULL,
	[GROUP_CODE] [varchar](100) NULL,
	[BASIC_CODE] [varchar](20) NULL,
	[CATEGORY_TYPE] [varchar](1) NULL,
	[VIEW_TYPE] [varchar](1) NULL,
	[LINK_URL] [varchar](200) NULL,
	[IMAGE_URL] [varchar](200) NULL,
	[BEST_CODE] [varchar](50) NULL,
	[FONT_STYLE] [varchar](30) NULL,
	[FONT_COLOR] [varchar](10) NULL,
	[ORDER_TYPE] [int] NULL,
	[ORDER_NUM] [int] NULL,
	[USE_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[MENU_TYPE] [int] NULL,
	[GROUP_REGION] [varchar](20) NULL,
	[GROUP_ATTRIBUTE] [varchar](20) NULL,
 CONSTRAINT [PK_MNU_MASTER_REL_JG_BAK] PRIMARY KEY CLUSTERED 
(
	[SITE_CODE] ASC,
	[MENU_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
