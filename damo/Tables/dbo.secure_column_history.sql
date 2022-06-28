USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_column_history](
	[h_time] [datetime] NULL,
	[cmd_type] [char](2) NULL,
	[owner] [varchar](128) NULL,
	[table_name] [varchar](300) NULL,
	[column_name] [varchar](128) NULL,
	[data_type] [varchar](106) NULL,
	[data_length] [int] NULL,
	[data_precision] [int] NULL,
	[data_scale] [int] NULL,
	[nullable] [char](1) NULL,
	[default_length] [int] NULL,
	[data_default] [varchar](1000) NULL,
	[column_id] [int] NULL,
	[root_table_name] [varchar](300) NULL,
	[new_table_name] [varchar](300) NULL,
	[new_column_name] [varchar](128) NULL,
	[mode_cd] [char](1) NULL,
	[stat_cd] [char](1) NULL,
	[algorithm] [int] NULL,
	[op_mode] [int] NULL,
	[iv_type] [int] NULL,
	[key] [varchar](1024) NULL,
	[column_info] [varchar](12) NULL,
	[dep_valid] [varchar](10) NULL,
	[enc_range] [varchar](10) NULL,
	[drop_remain] [varchar](10) NULL,
	[enc_range_type] [varchar](5) NULL,
	[copy_table_name] [varchar](300) NULL,
	[collation_name] [varchar](256) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_column_history] ADD  CONSTRAINT [df__secure_co__h_tim__6fb49575]  DEFAULT (getdate()) FOR [h_time]
GO
