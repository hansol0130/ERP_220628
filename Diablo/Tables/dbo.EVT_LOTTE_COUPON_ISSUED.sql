USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_LOTTE_COUPON_ISSUED](
	[REQ_NO] [int] NULL,
	[ISSUE_NO] [int] NULL,
	[ISSUE_TYPE] [int] NULL,
	[ISSUER_CODE] [char](7) NULL,
	[ISSUE_DATE] [datetime] NULL,
	[LAST_YN] [char](1) NULL
) ON [PRIMARY]
GO
