USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_CTI_MGERGE_NOR](
	[CUS_NO] [int] NOT NULL,
	[CUS_NAME] [varchar](20) NOT NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[DEL_YN] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
