USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVFILEUPLOAD](
	[TARGET_NO] [numeric](15, 0) NOT NULL,
	[CUSTOMER_ID] [varchar](50) NOT NULL,
	[CUSTOMER_NM] [varchar](100) NULL,
	[CUSTOMER_EMAIL] [varchar](100) NULL,
	[CUSTOMER_TEL] [varchar](15) NULL,
	[CUSTOMER_FAX] [varchar](15) NULL,
	[SLOT1] [varchar](100) NULL,
	[SLOT2] [varchar](100) NULL,
	[SLOT3] [varchar](100) NULL,
	[SLOT4] [varchar](100) NULL,
	[SLOT5] [varchar](100) NULL,
	[SLOT6] [varchar](100) NULL,
	[SLOT7] [varchar](100) NULL,
	[SLOT8] [varchar](100) NULL,
	[SLOT9] [varchar](100) NULL,
	[SLOT10] [varchar](100) NULL,
	[SLOT11] [varchar](100) NULL,
	[SLOT12] [varchar](100) NULL,
	[SLOT13] [varchar](100) NULL,
	[SLOT14] [varchar](100) NULL,
	[SLOT15] [varchar](100) NULL,
	[SLOT16] [varchar](100) NULL,
	[SLOT17] [varchar](100) NULL,
	[SLOT18] [varchar](100) NULL,
	[SLOT19] [varchar](100) NULL,
	[SLOT20] [varchar](100) NULL,
	[SLOT21] [varchar](100) NULL,
	[SLOT22] [varchar](100) NULL,
	[SLOT23] [varchar](100) NULL,
	[SLOT24] [varchar](100) NULL,
	[SLOT25] [varchar](100) NULL,
	[SLOT26] [varchar](100) NULL,
	[SLOT27] [varchar](100) NULL,
	[SLOT28] [varchar](100) NULL,
	[SLOT29] [varchar](100) NULL,
	[SLOT30] [varchar](100) NULL,
	[SLOT31] [varchar](100) NULL,
	[SLOT32] [varchar](100) NULL,
	[SLOT33] [varchar](100) NULL,
	[SLOT34] [varchar](100) NULL,
	[SLOT35] [varchar](100) NULL,
	[SLOT36] [varchar](100) NULL,
	[SLOT37] [varchar](100) NULL,
	[SLOT38] [varchar](100) NULL,
	[SLOT39] [varchar](100) NULL,
	[SLOT40] [varchar](100) NULL,
	[SLOT41] [varchar](100) NULL,
	[SLOT42] [varchar](100) NULL,
	[SLOT43] [varchar](100) NULL,
	[SLOT44] [varchar](100) NULL,
	[SLOT45] [varchar](100) NULL,
	[SLOT46] [varchar](100) NULL,
	[SLOT47] [varchar](100) NULL,
	[SLOT48] [varchar](100) NULL,
	[SLOT49] [varchar](100) NULL,
	[SLOT50] [varchar](100) NULL,
	[SEG] [varchar](20) NULL,
	[CALL_BACK] [varchar](50) NULL,
	[CUSTOMER_SLOT1] [varchar](50) NULL,
	[CUSTOMER_SLOT2] [varchar](50) NULL,
	[SENDER_NM] [varchar](50) NULL,
	[SENDER_EMAIL] [varchar](100) NULL,
	[RETMAIL_RECEIVER] [varchar](100) NULL,
	[SENTENCE] [varchar](2000) NULL,
 CONSTRAINT [PK_NVFILEUPLOAD] PRIMARY KEY CLUSTERED 
(
	[TARGET_NO] ASC,
	[CUSTOMER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO