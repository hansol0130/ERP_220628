USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVMIMEINFOLOG](
	[CAMPAIGN_NO] [numeric](15, 0) NOT NULL,
	[RESULT_SEQ] [numeric](16, 0) NOT NULL,
	[CUSTOMER_KEY] [varchar](50) NOT NULL,
	[LIST_SEQ] [varchar](10) NOT NULL,
	[RECORD_SEQ] [varchar](10) NOT NULL,
	[CUSTOMER_NM] [varchar](100) NULL,
	[CUSTOMER_EMAIL] [varchar](100) NOT NULL,
	[SID] [varchar](5) NOT NULL,
	[SEND_DT] [char](8) NULL,
	[SEND_TM] [char](6) NULL,
	[HANDLER_INDEX] [varchar](2) NULL,
	[FILE_INDEX] [varchar](2) NULL,
	[START_OFFSET] [numeric](15, 0) NULL,
	[END_OFFSET] [numeric](15, 0) NULL,
	[SLOT1] [varchar](100) NULL,
	[SLOT2] [varchar](100) NULL,
	[MIME_FULL_PATH] [varchar](250) NULL,
 CONSTRAINT [PK_NVMIMEINFOLOG] PRIMARY KEY CLUSTERED 
(
	[CAMPAIGN_NO] ASC,
	[RESULT_SEQ] ASC,
	[CUSTOMER_KEY] ASC,
	[LIST_SEQ] ASC,
	[RECORD_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVMIMEINFOLOG] ADD  DEFAULT ('0') FOR [RECORD_SEQ]
GO
