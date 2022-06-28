USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[EVT_RE_TOGETHER](
	[IDX] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NULL,
	[CUS_ID] [varchar](20) NULL,
	[CUS_NAME] [varchar](20) NULL,
	[NOR_TEL] [varchar](15) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](6) NULL,
	[NOR_TEL3] [varchar](6) NULL
) ON [PRIMARY]
GO
