USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MKT_MILEAGE_MASTER](
	[PARTNER_CODE] [varchar](5) NULL,
	[SEQ_NO] [int] NULL,
	[REQ_DATE] [datetime] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[EMP_CODE] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [dbo].[EMP_CODE] NULL,
	[RCV_DATE] [datetime] NULL,
	[RCV_YN] [char](1) NULL
) ON [PRIMARY]
GO
