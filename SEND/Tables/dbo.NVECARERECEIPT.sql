USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECARERECEIPT](
	[ECARE_NO] [numeric](15, 0) NOT NULL,
	[RESULT_SEQ] [numeric](16, 0) NOT NULL,
	[CUSTOMER_ID] [varchar](50) NOT NULL,
	[LIST_SEQ] [varchar](10) NOT NULL,
	[OPEN_DT] [char](8) NOT NULL,
	[OPEN_TM] [char](6) NOT NULL,
	[RECORD_SEQ] [varchar](10) NULL,
	[CUSTOMER_EMAIL] [varchar](100) NOT NULL,
	[CUSTOMER_NM] [varchar](100) NULL,
	[NULL_YN] [char](1) NULL,
	[READING_DT] [char](8) NULL,
	[READING_TM] [char](6) NULL,
	[READING_DURATION] [numeric](10, 0) NULL,
	[VALID_CNT] [numeric](10, 0) NULL,
 CONSTRAINT [PK_NVECARERECEIPT] PRIMARY KEY CLUSTERED 
(
	[ECARE_NO] ASC,
	[RESULT_SEQ] ASC,
	[CUSTOMER_ID] ASC,
	[LIST_SEQ] ASC,
	[OPEN_DT] ASC,
	[OPEN_TM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVECARERECEIPT] ADD  DEFAULT ('0') FOR [RECORD_SEQ]
GO
