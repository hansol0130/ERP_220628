USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_login_ctrl](
	[user_name] [varchar](255) NOT NULL,
	[parameter] [varchar](64) NULL,
	[value] [varchar](256) NULL,
	[flag] [varchar](32) NULL
) ON [PRIMARY]
GO
