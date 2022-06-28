USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KICC_PAY_RESPONSE](
	[REQ_CTR_NO] [varchar](30) NULL,
	[MCH_SEQ] [int] NULL,
	[RES_CTR_NO] [varchar](30) NULL,
	[APPR_YN] [char](1) NULL,
	[PAY_SEQ] [int] NULL,
	[AMOUNT] [int] NULL,
	[CARD_NUM] [varchar](20) NULL,
	[RESULT_CODE] [char](4) NULL,
	[RESULT_MSG] [varchar](100) NULL,
	[REMARK] [varchar](max) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[REQ_SEQ_NO] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
