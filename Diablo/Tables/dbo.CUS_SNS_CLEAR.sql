USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_SNS_CLEAR](
	[CUS_SNS_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NULL,
	[CHECK_YN] [int] NULL,
	[CHECK_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_SNS_CLEAR] PRIMARY KEY CLUSTERED 
(
	[CUS_SNS_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_SNS_CLEAR] ADD  CONSTRAINT [DEF_CUS_SNS_CLEAR_CHECK_YN]  DEFAULT ('N') FOR [CHECK_YN]
GO
ALTER TABLE [dbo].[CUS_SNS_CLEAR] ADD  CONSTRAINT [DEF_CUS_SNS_CLEAR_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
