USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_EMP_CUS_MEMBER](
	[CUS_NO] [int] NULL,
	[CUS_NAME] [varchar](50) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[EMP_CODE] [varchar](7) NULL,
	[REC_CNT] [int] NULL
) ON [PRIMARY]
GO
