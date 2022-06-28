USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMS_SEND_MASTER](
	[TRAN_PR] [int] NOT NULL,
	[RES_CODE] [varchar](12) NULL,
	[CUS_NO] [int] NULL,
	[CUS_NAME] [varchar](20) NULL,
	[AGT_CODE] [varchar](10) NULL,
	[EMP_SEQ] [int] NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
