USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_PUSH_SEND_HISTORY_BACKUP](
	[SEND_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[MSG_NO] [int] NOT NULL,
	[RES_TIME] [datetime] NULL,
	[RECV_AGE] [varchar](50) NOT NULL,
	[RECV_GENDER] [varchar](1) NOT NULL,
	[RECV_OS_TYPE] [varchar](10) NOT NULL,
	[RECV_CODE_TYPE] [varchar](3) NOT NULL,
	[RECV_CODE] [varchar](100) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [varchar](7) NOT NULL,
	[CANCEL_YN] [varchar](1) NOT NULL,
	[ERP_CNT] [int] NOT NULL,
	[SEND_CNT] [int] NOT NULL,
	[RECV_CNT] [int] NOT NULL,
	[RES_HISTORY] [varchar](10) NULL,
	[SEND_TYPE] [varchar](1) NULL,
	[RECV_MEM_CNT] [int] NOT NULL,
	[RECV_ETC_CNT] [int] NOT NULL,
	[RECV_AND_CNT] [int] NOT NULL,
	[RECV_IOS_CNT] [int] NOT NULL,
	[RECV_BLK_CNT] [int] NOT NULL,
	[RECV_FAL_CNT] [int] NOT NULL,
	[RECV_MEMBER] [varchar](1) NULL
) ON [PRIMARY]
GO
