USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMP_HOLIDAY_HISTORY_TEMP](
	[EDI_CODE] [dbo].[EDI_CODE] NOT NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
	[APPLY_YEAR] [char](4) NULL,
	[HOLIDAY_TYPE] [char](1) NULL,
	[SAL_TYPE] [char](1) NULL,
	[APPLY_YN] [char](1) NULL,
	[HOLIDAY_CODE] [dbo].[PUB_CODE] NULL,
	[JOIN_DATE] [smalldatetime] NULL,
	[OUT_DATE] [smalldatetime] NULL,
	[USE_DAY] [numeric](18, 1) NULL,
	[REMARK] [varchar](200) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[HOLIDAY_USE_DAY] [numeric](18, 1) NULL
) ON [PRIMARY]
GO
