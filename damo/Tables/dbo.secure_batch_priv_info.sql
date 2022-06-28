USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_batch_priv_info](
	[user_name] [varchar](255) NOT NULL,
	[owner] [varchar](128) NOT NULL,
	[table_name] [varchar](300) NOT NULL,
	[column_name] [varchar](128) NOT NULL,
	[context] [varchar](4000) NULL,
 CONSTRAINT [secure_batch_priv_info_pk] PRIMARY KEY CLUSTERED 
(
	[user_name] ASC,
	[owner] ASC,
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_batch_priv_info]  WITH CHECK ADD  CONSTRAINT [secure_batch_priv_info_fk1] FOREIGN KEY([user_name])
REFERENCES [dbo].[secure_user_info] ([user_name])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[secure_batch_priv_info] CHECK CONSTRAINT [secure_batch_priv_info_fk1]
GO
ALTER TABLE [dbo].[secure_batch_priv_info]  WITH CHECK ADD  CONSTRAINT [secure_batch_priv_info_fk2] FOREIGN KEY([owner], [table_name], [column_name])
REFERENCES [dbo].[secure_column_info] ([owner], [table_name], [column_name])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[secure_batch_priv_info] CHECK CONSTRAINT [secure_batch_priv_info_fk2]
GO
