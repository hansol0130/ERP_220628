USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_SYS_INFLOW_LOG_NEW](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[IN_DATE] [datetime] NULL,
	[IN_IP] [varchar](20) NULL,
	[IN_PATH] [varchar](500) NULL,
	[IN_URL] [varchar](1000) NULL,
	[IN_QUERY] [varchar](500) NULL,
	[INFLOW] [varchar](50) NULL,
	[IN_TYPE1] [varchar](50) NULL,
	[IN_TYPE2] [varchar](50) NULL,
	[IN_PRO_CODE] [varchar](100) NULL,
	[IN_MASTER_CODE] [varchar](100) NULL
) ON [PRIMARY]
GO
