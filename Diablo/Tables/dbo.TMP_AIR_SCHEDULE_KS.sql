USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_AIR_SCHEDULE_KS](
	[SEQ_NO] [int] NULL,
	[RTG_NO] [int] NULL,
	[SEG_NO] [int] NULL,
	[DEP_DATE] [datetime] NULL,
	[DEP_AIRPORT] [char](3) NULL,
	[ARR_DATE] [datetime] NULL,
	[ARR_AIRPORT] [char](3) NULL,
	[CODE_SHARE] [varchar](10) NULL,
	[OPER_AIRLINE] [char](2) NULL,
	[MAKT_AIRLINE] [char](2) NULL,
	[VIA_COUNT] [int] NULL,
	[FLT_NUMBER] [varchar](10) NULL,
	[EQT_NUMBER] [varchar](10) NULL,
	[BKG_CODE] [char](1) NULL,
	[BKG_REMAIN] [int] NULL,
	[DIRECTION] [int] NULL,
	[DEP_AIRPORT_NAME] [varchar](40) NULL,
	[ARR_AIRPORT_NAME] [varchar](40) NULL,
	[OPER_AIRLINE_NAME] [varchar](40) NULL
) ON [PRIMARY]
GO
