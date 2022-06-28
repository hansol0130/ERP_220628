USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[TBU_PRODUCT](
	[PRO_CODE] [varchar](20) NOT NULL,
	[ATT_CODE] [char](1) NULL,
	[REGION_CODE] [char](3) NULL,
	[DEP_DATE] [date] NULL,
	[PROFIT_PRICE] [decimal](18, 0) NULL,
	[MASTER_CODE] [varchar](10) NULL
) ON [PRIMARY]
GO