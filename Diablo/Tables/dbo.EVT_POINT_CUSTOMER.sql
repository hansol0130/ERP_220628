USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_POINT_CUSTOMER](
	[CUS_NO] [int] NULL,
	[CUS_ID] [varchar](20) NULL,
	[CUS_KEY_NO] [int] NULL,
	[CUS_KEY] [varchar](10) NULL,
	[CUS_NAME] [varchar](50) NULL,
	[NOR_TEL1] [varchar](3) NULL,
	[NOR_TEL2] [varchar](4) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[EMAIL] [varchar](50) NULL,
	[BIRTH_DATE] [datetime] NULL,
	[FIRST_END_DATE] [datetime] NULL,
	[FIRST_END_POINT] [int] NULL,
	[REMAIN_POINT] [int] NULL,
	[USE_YN] [char](1) NULL,
	[TRAN_PR_ID] [int] NULL,
	[EVT_VER] [int] NULL,
	[RES_CODE] [varchar](12) NULL,
	[KKO_SN] [varchar](100) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EVT_POINT_CUSTOMER] ADD  DEFAULT ('Y') FOR [USE_YN]
GO
