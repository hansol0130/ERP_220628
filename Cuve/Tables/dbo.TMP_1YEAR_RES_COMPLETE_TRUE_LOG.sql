USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_1YEAR_RES_COMPLETE_TRUE_LOG](
	[RES_LOG_SEQ] [bigint] NULL,
	[IN_IP] [varchar](20) NULL,
	[접속시간] [datetime] NULL,
	[IN_MASTER_CODE] [varchar](100) NULL,
	[RES_CODE] [varchar](24) NULL,
	[예약시간] [datetime] NULL,
	[MASTER_CODE] [varchar](10) NULL
) ON [PRIMARY]
GO
