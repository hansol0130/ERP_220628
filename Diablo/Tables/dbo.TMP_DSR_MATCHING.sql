USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_DSR_MATCHING](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[RES_SEQ_NO] [int] NOT NULL,
	[last_name] [varchar](20) NULL,
	[first_name] [varchar](20) NULL,
	[DEP_DATE] [datetime] NULL
) ON [PRIMARY]
GO
