USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_connect_ctrl](
	[col_seq] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](255) NULL,
	[ip_info] [varchar](4000) NULL,
	[service_info] [varchar](512) NULL,
	[time_info] [varchar](256) NULL,
	[mac_info] [varchar](256) NULL,
	[osuser_info] [varchar](256) NULL,
	[flag] [varchar](256) NULL,
	[use_acl] [varchar](16) NULL,
	[comments] [varchar](1024) NULL
) ON [PRIMARY]
GO
