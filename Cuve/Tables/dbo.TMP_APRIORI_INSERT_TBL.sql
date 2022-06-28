USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_APRIORI_INSERT_TBL](
	[MASTER_CODE] [varchar](20) NULL,
	[LHS] [varchar](100) NULL,
	[RHS] [varchar](100) NULL,
	[SUPPORT] [numeric](18, 15) NULL,
	[CONFIDENCE] [numeric](18, 15) NULL,
	[LIFT] [numeric](18, 15) NULL
) ON [PRIMARY]
GO
