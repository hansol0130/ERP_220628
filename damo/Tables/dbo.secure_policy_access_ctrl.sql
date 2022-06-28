USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_policy_access_ctrl](
	[col_seq] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](255) NOT NULL,
	[sp_alias] [varchar](64) NULL,
	[ip_info] [varchar](4000) NULL,
	[service_info] [varchar](4000) NULL,
	[mac_info] [varchar](4000) NULL,
	[osuser_info] [varchar](4000) NULL,
	[start_date] [varchar](200) NULL,
	[end_date] [varchar](200) NULL,
	[start_time] [varchar](200) NULL,
	[end_time] [varchar](200) NULL,
	[wday] [varchar](200) NULL,
	[flag] [varchar](256) NULL,
	[use_acl] [varchar](16) NULL,
	[comments] [varchar](200) NULL,
 CONSTRAINT [pk_secure_policy_access_ctrl] PRIMARY KEY CLUSTERED 
(
	[col_seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
