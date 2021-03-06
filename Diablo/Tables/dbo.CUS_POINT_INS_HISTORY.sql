USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_POINT_INS_HISTORY](
	[CUS_NAME] [varchar](50) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[CUS_NO] [int] NULL,
	[POINT_NO] [int] NULL,
	[INS_TYPE] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_POINT_INS_HISTORY] ADD  DEFAULT ((0)) FOR [INS_TYPE]
GO
