USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_original_column](
	[owner] [varchar](128) NOT NULL,
	[table_name] [varchar](300) NOT NULL,
	[column_name] [varchar](128) NOT NULL,
	[column_id] [int] NULL,
	[identity_yn] [char](1) NULL,
	[calcu_yn] [char](1) NULL,
	[default_yn] [char](1) NOT NULL,
	[default_name] [varchar](128) NULL,
	[total_rows] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_original_column] ADD  CONSTRAINT [df_secure_original_column_identity_yn]  DEFAULT ('N') FOR [identity_yn]
GO
ALTER TABLE [dbo].[secure_original_column] ADD  CONSTRAINT [df_secure_original_column_calcu_yn]  DEFAULT ('N') FOR [calcu_yn]
GO
ALTER TABLE [dbo].[secure_original_column] ADD  CONSTRAINT [df_secure_original_column_default_yn]  DEFAULT ('N') FOR [default_yn]
GO
