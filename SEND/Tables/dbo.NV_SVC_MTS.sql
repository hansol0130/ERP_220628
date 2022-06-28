USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NV_SVC_MTS](
	[T_ID] [varchar](31) NOT NULL,
	[SERVER_ID] [varchar](10) NOT NULL,
	[START_TM] [varchar](14) NULL,
	[END_TM] [varchar](14) NULL,
	[SERVICE_STS] [varchar](2) NULL,
	[TOT_CNT] [numeric](10, 0) NULL,
	[MADE_CNT] [numeric](10, 0) NULL,
	[MAX_RETRY] [numeric](10, 0) NULL,
	[SEND_CNT] [numeric](10, 0) NULL,
	[SUCCESS_CNT] [numeric](10, 0) NULL,
	[UNKNOWN_USER_CNT] [numeric](10, 0) NULL,
	[UNKNOWN_HOST_CNT] [numeric](10, 0) NULL,
	[SMTP_EXCEPT_CNT] [numeric](10, 0) NULL,
	[NO_ROUTE_CNT] [numeric](10, 0) NULL,
	[REFUSED_CNT] [numeric](10, 0) NULL,
	[ETC_EXCEPT_CNT] [numeric](10, 0) NULL,
	[INVALID_ADDR_CNT] [numeric](10, 0) NULL,
	[QUEUE_CNT] [numeric](4, 0) NULL,
	[THREAD_CNT] [numeric](4, 0) NULL,
	[HANDLER_THREAD_CNT] [numeric](4, 0) NULL,
	[ERR_MSG] [varchar](500) NULL,
	[UPDATE_TM] [varchar](14) NULL,
	[CREATE_TM] [varchar](14) NULL,
 CONSTRAINT [PK_NV_SVC_MTS] PRIMARY KEY CLUSTERED 
(
	[T_ID] ASC,
	[SERVER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
