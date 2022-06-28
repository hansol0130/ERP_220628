USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_SC_ANAL](
	[SIGN_CODE] [varchar](1) NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[DEP_DATE] [datetime] NULL,
	[MIN_COUNT] [int] NULL,
	[예약인원] [int] NULL,
	[TOUR_DAY] [int] NULL,
	[DEP_TRANS_CODE] [char](2) NULL,
	[AVG_ADT_PRICE] [int] NULL,
	[방문국가수] [int] NULL,
	[지역] [varchar](40) NULL
) ON [PRIMARY]
GO
