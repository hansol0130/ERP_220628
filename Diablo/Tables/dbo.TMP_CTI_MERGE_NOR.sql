USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_CTI_MERGE_NOR](
	[CUS_NO] [int] NOT NULL,
	[CUS_NAME] [varchar](20) NOT NULL,
	[HOM_TEL1] [varchar](6) NULL,
	[HOM_TEL2] [varchar](5) NULL,
	[HOM_TEL3] [varchar](4) NULL,
	[DEL_YN] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
