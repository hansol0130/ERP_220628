USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_policy_batch_table](
	[owner] [varchar](128) NOT NULL,
	[table_name] [varchar](300) NOT NULL,
	[column_name] [varchar](128) NOT NULL,
	[service_id] [varchar](64) NOT NULL,
	[status] [int] NULL,
	[group_id] [int] NULL,
 CONSTRAINT [pk_secure_policy_batch_table] PRIMARY KEY CLUSTERED 
(
	[owner] ASC,
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_policy_batch_table]  WITH CHECK ADD  CONSTRAINT [fk_secure_policy_batch_table] FOREIGN KEY([service_id])
REFERENCES [dbo].[secure_kms_service_column] ([service_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[secure_policy_batch_table] CHECK CONSTRAINT [fk_secure_policy_batch_table]
GO
