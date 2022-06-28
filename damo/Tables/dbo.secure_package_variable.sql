USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_package_variable](
	[session_id] [varchar](32) NULL,
	[var_name] [varchar](128) NULL,
	[value] [varchar](1024) NULL
) ON [PRIMARY]
GO
