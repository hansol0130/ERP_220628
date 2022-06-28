USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_BANNER_old](
	[BNR_TYPE] [int] NOT NULL,
	[BNR_SEQ] [int] NOT NULL,
	[BNR_NAME] [varchar](200) NULL,
	[IMG_URL] [varchar](200) NULL,
	[LINK_URL] [varchar](500) NULL,
	[START_DATE] [char](10) NULL,
	[START_TIME] [char](8) NULL,
	[END_DATE] [char](10) NULL,
	[END_TIME] [char](8) NULL,
	[DAY_START_TIME] [char](8) NULL,
	[DAY_END_TIME] [char](8) NULL,
	[SHOW_DAY] [char](7) NULL,
	[IS_USE] [int] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[ORDER_NO] [int] NULL
) ON [PRIMARY]
GO
