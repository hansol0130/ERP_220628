USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_RES_HISTORY](
	[CUS_NAME] [varchar](40) NULL,
	[birth_date] [varchar](10) NULL,
	[AGE] [varchar](10) NULL,
	[GENDER] [char](1) NULL,
	[DEP_DATE] [datetime] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[유럽] [int] NULL,
	[동남아] [int] NULL,
	[중국] [int] NULL,
	[일본] [int] NULL,
	[대양주] [int] NULL,
	[괌사이판] [int] NULL,
	[국내] [int] NULL,
	[미주] [int] NULL,
	[기타] [int] NULL
) ON [PRIMARY]
GO
