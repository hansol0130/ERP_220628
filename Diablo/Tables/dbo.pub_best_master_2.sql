USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pub_best_master_2](
	[TPL_SEQ] [int] NOT NULL,
	[MST_SEQ] [int] NOT NULL,
	[MST_NAME] [varchar](50) NULL,
	[CITY_CODE] [char](3) NULL,
	[TYPE_SEQ] [int] NULL,
	[TYPE_NAME] [varchar](50) NULL,
	[MST_REMARK] [varchar](400) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[ORDER_NUM] [int] NULL
) ON [PRIMARY]
GO
