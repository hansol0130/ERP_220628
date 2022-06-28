USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVRESENDREQUEST](
	[REQ_DT] [varchar](14) NOT NULL,
	[SEND_FG] [char](1) NOT NULL,
	[SERVICE_NO] [numeric](15, 0) NOT NULL,
	[SUPER_SEQ] [numeric](16, 0) NOT NULL,
	[RESULT_SEQ] [numeric](16, 0) NULL,
	[LIST_SEQ] [varchar](10) NULL,
	[TARGET_KEY] [varchar](100) NULL,
	[TARGET_CONTACT] [varchar](100) NULL,
	[CLIENT] [varchar](2) NOT NULL,
	[SUB_TYPE] [char](1) NOT NULL,
	[CHANNEL] [char](1) NOT NULL,
	[RESEND_TYPE] [char](1) NOT NULL,
	[RESEND_REASON] [varchar](1000) NULL
) ON [PRIMARY]
GO
