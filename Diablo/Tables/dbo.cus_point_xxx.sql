USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cus_point_xxx](
	[CUS_NO] [dbo].[CUS_NO] NOT NULL,
	[POINT_NO] [int] NOT NULL,
	[POINT_TYPE] [int] NOT NULL,
	[ACC_USE_TYPE] [int] NOT NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[POINT_PRICE] [money] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[TITLE] [nvarchar](200) NULL,
	[TOTAL_PRICE] [money] NOT NULL,
	[MASTER_SEQ] [int] NULL,
	[BOARD_SEQ] [int] NULL,
	[REMARK] [varchar](200) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NOT NULL,
	[IS_CXL] [tinyint] NULL,
	[ORG_POINT_NO] [int] NULL
) ON [PRIMARY]
GO
