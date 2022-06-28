USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_JOIN_LOG](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[LOG_SEQ_NO] [int] NULL,
	[ROUTE_INFO] [varchar](1000) NULL,
	[USER_AGENT] [varchar](4000) NULL,
	[CUS_ID] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
	[TRACE] [varchar](4000) NULL,
	[JOIN_TYPE] [int] NULL,
	[IS_SNS] [int] NULL,
	[OLD_JOIN_TYPE] [int] NULL
) ON [PRIMARY]
GO
