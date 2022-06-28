USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_migration_result](
	[owner] [varchar](128) NOT NULL,
	[table_name] [varchar](300) NOT NULL,
	[type] [varchar](64) NOT NULL,
	[name] [varchar](256) NOT NULL,
	[new_name] [varchar](256) NULL,
	[status] [int] NULL,
	[isDamo] [int] NULL,
 CONSTRAINT [pk_secure_migration_result] PRIMARY KEY CLUSTERED 
(
	[owner] ASC,
	[table_name] ASC,
	[type] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_migration_result] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[secure_migration_result] ADD  DEFAULT ((0)) FOR [isDamo]
GO
