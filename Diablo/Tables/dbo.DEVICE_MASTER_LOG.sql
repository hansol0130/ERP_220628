USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEVICE_MASTER_LOG](
	[SEQ] [bigint] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NULL,
	[DEVICE_NO] [varchar](512) NULL,
	[CUS_DEVICE_ID] [varchar](4000) NULL,
	[NEW_CUS_DEVICE_ID] [varchar](4000) NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO