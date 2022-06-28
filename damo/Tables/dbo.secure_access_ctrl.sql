USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_access_ctrl](
	[col_seq] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](255) NULL,
	[owner] [varchar](128) NULL,
	[table_name] [varchar](300) NULL,
	[column_name] [varchar](128) NULL,
	[ip_info] [varchar](4000) NULL,
	[service_info] [varchar](512) NULL,
	[mac_info] [varchar](256) NULL,
	[osuser_info] [varchar](256) NULL,
	[flag] [varchar](256) NULL,
	[use_acl] [varchar](16) NULL,
	[comments] [varchar](1024) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_access_ctrl]  WITH CHECK ADD  CONSTRAINT [secure_access_ctrl_fk] FOREIGN KEY([owner], [table_name], [column_name])
REFERENCES [dbo].[secure_column_info] ([owner], [table_name], [column_name])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[secure_access_ctrl] CHECK CONSTRAINT [secure_access_ctrl_fk]
GO
