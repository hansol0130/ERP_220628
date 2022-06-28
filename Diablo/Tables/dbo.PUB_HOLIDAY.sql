USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_HOLIDAY](
	[HOLIDAY] [varchar](10) NOT NULL,
	[HOLIDAY_NAME] [varchar](20) NULL,
	[IS_HOLIDAY] [char](1) NOT NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_HOLIDAY] ADD  CONSTRAINT [DEF_PUB_HOLIDAY_IS_HOLIDAY]  DEFAULT ('Y') FOR [IS_HOLIDAY]
GO
