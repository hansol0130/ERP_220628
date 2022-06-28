USE [damolog]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_log](
	[log_seq] [bigint] IDENTITY(1,1) NOT NULL,
	[log_time] [datetime] NOT NULL,
	[log_thread] [int] NULL,
	[log_category] [varchar](128) NOT NULL,
	[access_type] [char](1) NULL,
	[session_id] [smallint] NULL,
	[log_ip] [varchar](16) NULL,
	[mac_addr] [varchar](64) NULL,
	[logon_time] [varchar](24) NULL,
	[service_name] [varchar](256) NULL,
	[service_host] [varchar](256) NULL,
	[os_user] [varchar](128) NULL,
	[log_user] [varchar](128) NULL,
	[log_owner] [varchar](256) NULL,
	[log_table] [varchar](300) NULL,
	[log_column] [varchar](2000) NULL,
	[policy] [varchar](64) NULL,
	[log_type] [char](1) NULL,
	[log_job] [varchar](256) NULL,
	[log_desc] [varchar](2000) NULL,
 CONSTRAINT [secure_log_pk] PRIMARY KEY CLUSTERED 
(
	[log_seq] ASC,
	[log_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
