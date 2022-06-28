USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_access_info](
	[user_name] [varchar](255) NULL,
	[owner] [varchar](128) NULL,
	[table_name] [varchar](300) NULL,
	[column_name] [varchar](128) NULL,
	[ip_info] [varchar](256) NULL,
	[i_flag] [varchar](2) NULL,
	[service_info] [varchar](256) NULL,
	[s_flag] [varchar](2) NULL,
	[time_info] [varchar](256) NULL,
	[t_flag] [varchar](2) NULL,
	[use_acl] [varchar](6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_access_info]  WITH CHECK ADD  CONSTRAINT [secure_access_info_fk] FOREIGN KEY([owner], [table_name], [column_name])
REFERENCES [dbo].[secure_column_info] ([owner], [table_name], [column_name])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[secure_access_info] CHECK CONSTRAINT [secure_access_info_fk]
GO
