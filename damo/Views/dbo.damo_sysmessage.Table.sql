USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[damo_sysmessage](
	[error] [int] NULL,
	[severity] [int] NULL,
	[dlevel] [int] NULL,
	[description] [varchar](4000) NULL
) ON [PRIMARY]
GO
