USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_MASTER_MANAGE](
	[SEQ_NO] [int] NULL,
	[TEAM_CODE] [varchar](3) NULL,
	[TEAM_NAME] [varchar](100) NULL,
	[MASTER_CODE] [varchar](20) NULL,
	[MIN_DATE] [datetime] NULL,
	[MAX_DATE] [datetime] NULL,
	[SEAT_YN] [varchar](1) NULL,
	[SEAT_REMARK] [varchar](1000) NULL,
	[USE_YN] [varchar](1) NULL,
	[DEL_YN] [varchar](1) NULL,
	[USER_RANK] [int] NULL,
	[REMARK] [varchar](4000) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[EMP_CODE] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [dbo].[EMP_CODE] NULL
) ON [PRIMARY]
GO
