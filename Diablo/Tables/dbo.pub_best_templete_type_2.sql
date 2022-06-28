USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pub_best_templete_type_2](
	[TPL_SEQ] [int] NOT NULL,
	[TYPE_SEQ] [int] NOT NULL,
	[TYPE_NAME] [varchar](30) NULL,
	[TYPE_REMARK] [varchar](100) NULL,
	[NEW_CODE] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [varchar](20) NULL,
	[EDT_DATE] [datetime] NULL
) ON [PRIMARY]
GO
