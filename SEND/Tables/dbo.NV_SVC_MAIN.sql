USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NV_SVC_MAIN](
	[T_ID] [varchar](31) NOT NULL,
	[SERVER_ID] [varchar](10) NOT NULL,
	[START_TM] [varchar](14) NULL,
	[END_TM] [varchar](14) NULL,
	[SERVICE_STS] [varchar](2) NULL,
	[SERVICE_NM] [varchar](100) NULL,
	[SEND_MODE] [char](1) NULL,
	[SERVICE_TYPE] [char](1) NULL,
	[CLIENT] [varchar](2) NULL,
	[USER_ID] [varchar](20) NULL,
	[MTS_CNT] [numeric](2, 0) NULL,
	[TARGET_CNT] [numeric](10, 0) NULL,
	[CHANNEL] [char](1) NULL,
	[ETC_INFO] [varchar](500) NULL,
	[ERR_MSG] [varchar](500) NULL,
	[DISPLAY_YN] [varchar](1) NULL,
	[STATUS] [varchar](2) NULL,
	[DEL_YN] [char](1) NULL,
	[RTN_MAIL_CNT] [numeric](10, 0) NULL,
	[RCV_CNFM_EM] [numeric](10, 0) NULL,
	[LNK_TRC_EM] [numeric](10, 0) NULL,
	[RCV_CNFM_EC] [numeric](10, 0) NULL,
	[RCV_TRC_EC] [numeric](10, 0) NULL,
	[RCV_USR_DEF] [numeric](10, 0) NULL,
	[UPDATE_TM] [varchar](14) NULL,
	[CREATE_TM] [varchar](14) NULL,
 CONSTRAINT [PK_NV_SVC_MAIN] PRIMARY KEY CLUSTERED 
(
	[T_ID] ASC,
	[SERVER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
