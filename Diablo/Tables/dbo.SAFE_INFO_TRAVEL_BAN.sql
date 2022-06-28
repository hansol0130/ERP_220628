USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAFE_INFO_TRAVEL_BAN](
	[ID] [varchar](20) NOT NULL,
	[CONTINENT] [varchar](60) NULL,
	[COUNTRY_NAME] [varchar](50) NULL,
	[COUNTRY_EN_NAME] [varchar](50) NULL,
	[BAN] [varchar](20) NULL,
	[BAN_PARTIAL] [varchar](20) NULL,
	[BAN_NOTE] [varchar](500) NULL,
	[IMG_URL1] [varchar](100) NULL,
	[IMG_URL2] [varchar](100) NULL,
	[WRT_DT] [datetime] NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SAFE_INFO_TRAVEL_BAN] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
