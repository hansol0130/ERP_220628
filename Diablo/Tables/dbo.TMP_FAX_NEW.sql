USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_FAX_NEW](
	[FAXID] [varchar](255) NULL,
	[FAX_NUM] [varchar](255) NULL,
	[EMP_CODE] [char](7) NULL,
	[EMP_NAME] [varchar](255) NULL,
	[TEAM_CODE] [char](3) NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[FAX_GROUP] [int] NULL
) ON [PRIMARY]
GO
