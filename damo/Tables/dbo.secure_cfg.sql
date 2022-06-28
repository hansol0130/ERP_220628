USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_cfg](
	[section] [varchar](64) NULL,
	[parameter] [varchar](64) NULL,
	[value] [varchar](4096) NOT NULL
) ON [PRIMARY]
GO
