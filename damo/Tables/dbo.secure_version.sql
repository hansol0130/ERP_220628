USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_version](
	[inst_day] [varchar](24) NULL,
	[file_name] [varchar](64) NULL,
	[version_str] [varchar](12) NULL,
	[etc_1] [varchar](64) NULL
) ON [PRIMARY]
GO
