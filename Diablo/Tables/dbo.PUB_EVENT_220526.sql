USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_EVENT_220526](
	[EVT_SEQ] [int] NOT NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[SIGN_CODE] [varchar](20) NULL,
	[ATT_CODE] [varchar](20) NULL,
	[EVT_NAME] [varchar](500) NULL,
	[EVT_SHORT_REMARK] [varchar](100) NULL,
	[EVT_URL] [varchar](500) NULL,
	[BANNER_URL] [varchar](500) NULL,
	[SHOW_ORDER] [int] NULL,
	[EVT_YN] [char](1) NULL,
	[BEST_YN] [char](1) NULL,
	[SHOW_YN] [char](1) NULL,
	[COMMENT_YN] [char](1) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[DEV_YN] [char](1) NULL,
	[DEV_SHOW_TYPE] [tinyint] NULL,
	[PROVIDER] [varchar](20) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[READ_COUNT] [int] NULL,
	[BEST_BANNER_URL] [varchar](500) NULL,
	[DEP_AIRLINE_CODE] [varchar](3) NULL,
	[MOBILE_URL] [varchar](500) NULL,
	[EVT_DESC] [varchar](1000) NULL,
	[MASTER_CODE] [varchar](20) NULL
) ON [PRIMARY]
GO
