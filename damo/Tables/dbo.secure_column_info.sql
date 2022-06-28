USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_column_info](
	[owner] [varchar](128) NOT NULL,
	[table_name] [varchar](300) NOT NULL,
	[column_name] [varchar](128) NOT NULL,
	[data_type] [varchar](106) NULL,
	[data_length] [int] NOT NULL,
	[data_precision] [int] NULL,
	[data_scale] [int] NULL,
	[nullable] [char](2) NULL,
	[default_length] [int] NULL,
	[data_default] [varchar](1000) NULL,
	[column_id] [int] NULL,
	[root_table_name] [varchar](300) NOT NULL,
	[new_table_name] [varchar](300) NOT NULL,
	[new_column_name] [varchar](128) NOT NULL,
	[mode_cd] [char](1) NOT NULL,
	[stat_cd] [char](1) NULL,
	[algorithm] [int] NULL,
	[op_mode] [int] NULL,
	[iv_type] [int] NULL,
	[select_type] [int] NULL,
	[key] [varchar](1024) NULL,
	[column_info] [varchar](12) NULL,
	[dep_valid] [varchar](10) NULL,
	[enc_range] [varchar](10) NULL,
	[drop_remain] [varchar](10) NULL,
	[enc_range_type] [varchar](5) NULL,
	[copy_table_name] [varchar](300) NULL,
	[collation_name] [varchar](256) NULL,
	[sp_alias] [varchar](64) NULL,
	[service_id] [varchar](64) NULL,
 CONSTRAINT [secure_column_info_pk] PRIMARY KEY CLUSTERED 
(
	[owner] ASC,
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_column_info] ADD  CONSTRAINT [df_secure_column_info_data_length]  DEFAULT ((0)) FOR [data_length]
GO
ALTER TABLE [dbo].[secure_column_info] ADD  CONSTRAINT [df__secure_co__stat___719cdde7]  DEFAULT ('P') FOR [stat_cd]
GO
