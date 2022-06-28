USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[KT_ROAMING_CODE_LOG](
	[IDX] [int] IDENTITY(1,1) NOT NULL,
	[RES_CODE] [char](12) NULL,
	[CUS_NO] [int] NULL,
	[CONTS_TXT] [varchar](max) NULL,
	[CODE] [varchar](100) NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [onetime].[KT_ROAMING_CODE_LOG] ADD  CONSTRAINT [DF_KT_ROAMING_CODE_LOG_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
