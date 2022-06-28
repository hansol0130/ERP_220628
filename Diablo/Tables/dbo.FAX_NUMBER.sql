USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAX_NUMBER](
	[FAX_ID] [int] NULL,
	[FAX_NUMBER1] [varchar](4) NULL,
	[FAX_NUMBER2] [varchar](4) NULL,
	[FAX_NUMBER3] [varchar](4) NULL,
	[USE_YN] [char](1) NULL,
	[REMARK] [varchar](500) NULL,
	[NEW_CODE] [dbo].[EMP_CODE] NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
