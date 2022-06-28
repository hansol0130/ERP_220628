USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRO_TRANS_SEAT_DEL](
	[SEAT_CODE] [int] NOT NULL,
	[DEP_TRANS_CODE] [char](2) NOT NULL,
	[DEP_TRANS_NUMBER] [char](4) NOT NULL,
	[DEP_DEP_DATE] [datetime] NULL,
	[DEP_ARR_DATE] [datetime] NULL,
	[DEP_DEP_TIME] [char](5) NULL,
	[DEP_ARR_TIME] [char](5) NULL,
	[DEP_SPEND_TIME] [char](5) NULL,
	[DEP_DEP_AIRPORT_CODE] [char](3) NULL,
	[DEP_ARR_AIRPORT_CODE] [char](3) NULL,
	[ARR_TRANS_CODE] [char](2) NOT NULL,
	[ARR_TRANS_NUMBER] [char](4) NOT NULL,
	[ARR_DEP_DATE] [datetime] NULL,
	[ARR_ARR_DATE] [datetime] NULL,
	[ARR_DEP_TIME] [char](5) NULL,
	[ARR_ARR_TIME] [char](5) NULL,
	[ARR_SPEND_TIME] [char](5) NULL,
	[ARR_DEP_AIRPORT_CODE] [char](3) NULL,
	[ARR_ARR_AIRPORT_CODE] [char](3) NULL,
	[ADT_PRICE] [int] NULL,
	[CHD_PRICE] [int] NULL,
	[INF_PRICE] [int] NULL,
	[SEAT_COUNT] [int] NULL,
	[MAX_SEAT_COUNT] [int] NULL,
	[SEAT_TYPE] [int] NULL,
	[TRANS_TYPE] [int] NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[FARE_SEAT_TYPE] [int] NULL,
	[SYS_CHK_YN] [char](1) NULL,
	[SYS_CHK_REMARK] [char](1000) NULL,
	[SYS_CHK_DATE] [datetime] NULL
) ON [PRIMARY]
GO
