USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pub_best_detail_2](
	[TPL_SEQ] [int] NOT NULL,
	[MST_SEQ] [int] NOT NULL,
	[DTI_SEQ] [int] NOT NULL,
	[DTI_ITEM1] [varchar](50) NULL,
	[DTI_ITEM2] [varchar](50) NULL,
	[DTI_ITEM3] [varchar](100) NULL,
	[DTI_ITEM4] [varchar](50) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL
) ON [PRIMARY]
GO
