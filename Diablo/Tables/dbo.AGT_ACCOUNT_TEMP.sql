USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGT_ACCOUNT_TEMP](
	[AGT_CODE] [varchar](10) NOT NULL,
	[ACC_SEQ] [int] NOT NULL,
	[ACC_TYPE] [int] NULL,
	[ACC_NAME] [varchar](50) NULL,
	[REG_NUMBER] [varchar](20) NULL,
	[REG_DATE] [datetime] NULL,
	[MEMBER_CODE] [varchar](20) NULL,
	[REG_RATE] [decimal](3, 1) NULL,
	[ADMIN_REMARK] [varchar](300) NULL,
	[MGR_TEAM_CODE] [char](3) NULL,
	[SHOW_YN] [dbo].[USE_Y] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[REG_NAME] [varchar](20) NULL
) ON [PRIMARY]
GO
