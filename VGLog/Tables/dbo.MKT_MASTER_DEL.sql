USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MKT_MASTER_DEL](
	[PRO_CODE] [varchar](50) NOT NULL,
	[PRO_TYPE] [varchar](4) NOT NULL,
	[PRO_NAME] [varchar](200) NULL,
	[MIN_PRICE] [decimal](18, 0) NULL,
	[PRO_URL] [varchar](255) NULL,
	[IMG_URL] [varchar](255) NULL,
	[CATE1] [varchar](20) NULL,
	[CATE2] [varchar](20) NULL,
	[CATE3] [varchar](20) NULL,
	[CATE4] [varchar](20) NULL,
	[CATE_DESC1] [varchar](50) NULL,
	[CATE_DESC2] [varchar](50) NULL,
	[CATE_DESC3] [varchar](50) NULL,
	[CATE_DESC4] [varchar](50) NULL,
	[BLAND_NAME] [varchar](50) NULL,
	[EVENT_DESC] [varchar](50) NULL,
	[CARD_DESC] [varchar](50) NULL,
	[COUP_DESC] [varchar](50) NULL,
	[POINT] [varchar](50) NULL,
	[REGION_CODE] [varchar](300) NULL,
	[REGION_NAME] [varchar](500) NULL,
	[NATION_CODE] [varchar](300) NULL,
	[NATION_NAME] [varchar](500) NULL,
	[CITY_CODE] [varchar](300) NULL,
	[CITY_NAME] [varchar](500) NULL,
	[TEAM_CODE] [varchar](3) NULL,
	[USE_YN] [varchar](1) NULL,
	[AUTO_UPDATE_YN] [varchar](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [varchar](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [varchar](7) NULL,
	[AFF_CODE] [varchar](2) NULL,
 CONSTRAINT [PK_MKT_MASTER_DEL] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[PRO_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
