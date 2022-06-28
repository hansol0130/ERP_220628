USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_NAVER_MASTER](
	[SEQ_NO] [int] NULL,
	[TEAM_NAME] [varchar](255) NULL,
	[MASTER_CODE] [varchar](20) NULL,
	[TEAM_COMP_YN] [varchar](1) NULL,
	[MIN_DATE] [datetime] NULL,
	[MAX_DATE] [datetime] NULL,
	[PRO_ALL_CNT] [int] NULL,
	[PRO_SHOW_CNT] [int] NULL,
	[COMP_CNT] [int] NULL,
	[NOTFIN_CNT] [int] NULL,
	[INOUT] [varchar](1000) NULL,
	[SELLPOINT] [varchar](1000) NULL,
	[PROPOINT] [varchar](1000) NULL,
	[SEAT] [varchar](1000) NULL,
	[REMARK] [varchar](4000) NULL,
	[USE_YN] [varchar](1) NULL,
	[SEAT_YN] [varchar](1) NULL,
	[DEL_YN] [varchar](1) NULL,
	[SEAT_REMARK] [varchar](1000) NULL,
	[USER_RANK] [int] NULL
) ON [PRIMARY]
GO
