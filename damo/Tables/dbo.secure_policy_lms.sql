USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_policy_lms](
	[policy_id] [varchar](256) NOT NULL,
	[policy_user] [varchar](256) NULL,
	[owner] [varchar](128) NULL,
	[table_name] [varchar](300) NULL,
	[column_name] [varchar](128) NULL,
	[ip] [varchar](4000) NULL,
	[application] [varchar](4000) NULL,
	[start_time] [varchar](4000) NOT NULL,
	[end_time] [varchar](4000) NOT NULL,
	[service_flag] [int] NOT NULL,
	[check_amount] [int] NOT NULL,
	[check_unit] [int] NOT NULL
) ON [PRIMARY]
GO
