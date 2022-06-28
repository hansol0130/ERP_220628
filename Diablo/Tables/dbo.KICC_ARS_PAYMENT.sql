USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KICC_ARS_PAYMENT](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[REQ_CTR_NO] [varchar](30) NULL,
	[RES_CTR_NO] [varchar](20) NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[PAY_SEQ] [int] NULL,
	[KICC_ID] [varchar](15) NULL,
	[CUS_TEL] [varchar](20) NULL,
	[AMOUNT] [int] NULL,
	[RESULT_CODE] [char](4) NULL,
	[RESULT_MSG] [varchar](100) NULL,
	[APPR_YN] [char](1) NULL,
	[REMARK] [varchar](500) NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_DATE] [datetime] NULL
) ON [PRIMARY]
GO
