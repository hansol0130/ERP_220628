USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[em_log](
	[tran_pr] [int] NOT NULL,
	[tran_refkey] [varchar](40) NULL,
	[tran_id] [varchar](20) NULL,
	[tran_phone] [varchar](15) NOT NULL,
	[tran_callback] [varchar](15) NULL,
	[tran_status] [char](1) NULL,
	[tran_date] [datetime] NOT NULL,
	[tran_rsltdate] [datetime] NULL,
	[tran_reportdate] [datetime] NULL,
	[tran_rslt] [char](1) NULL,
	[tran_net] [varchar](3) NULL,
	[tran_msg] [varchar](255) NULL,
	[tran_etc1] [varchar](64) NULL,
	[tran_etc2] [varchar](16) NULL,
	[tran_etc3] [varchar](16) NULL,
	[tran_etc4] [int] NULL,
	[tran_type] [int] NOT NULL,
	[SERVICE_TYPE] [char](2) NULL,
	[SERVICE_NO] [bigint] NULL,
	[RESULT_SEQ] [bigint] NULL,
	[SEQ] [varchar](100) NULL,
	[SVC_ID] [varchar](20) NULL,
	[SLOT1] [varchar](100) NULL,
	[SLOT2] [varchar](100) NULL,
	[REQ_USER_ID] [varchar](100) NULL,
	[REQ_DEPT_ID] [varchar](100) NULL
) ON [PRIMARY]
GO
