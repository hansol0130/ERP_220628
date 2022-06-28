USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MKT_MILEAGE_DETAIL](
	[PARTNER_CODE] [varchar](5) NULL,
	[SEQ_NO] [int] NULL,
	[DETAIL_NO] [int] NULL,
	[AFF_CODE] [varchar](5) NULL,
	[SET_CODE] [varchar](1) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[MEM_NO] [varchar](9) NULL,
	[MEM_NAME] [varchar](50) NULL,
	[MILEAGE] [int] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[EMP_CODE] NULL,
	[RCV_DATE] [datetime] NULL,
	[RCV_CODE] [dbo].[EMP_CODE] NULL,
	[RESULT_CODE] [varchar](4) NULL,
	[COMP_YN] [char](1) NULL,
	[REQ_DATA] [varchar](52) NULL,
	[REMARK] [varchar](100) NULL
) ON [PRIMARY]
GO
