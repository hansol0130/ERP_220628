USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_column_algorithm_info](
	[owner] [varchar](128) NOT NULL,
	[table_name] [varchar](300) NOT NULL,
	[column_name] [varchar](128) NOT NULL,
	[constraint_cnt] [int] NULL,
	[stat_cd] [char](1) NULL,
	[enc_mode] [varchar](2) NULL,
	[algorithm] [int] NULL,
	[op_mode] [int] NULL,
	[iv_type] [int] NULL,
	[select_type] [int] NULL,
	[key] [varchar](1024) NULL,
	[enc_range] [varchar](16) NULL,
	[enc_null] [varchar](16) NULL,
	[enc_range_type] [varchar](5) NULL,
	[index_enc] [varchar](256) NULL,
	[sp_alias] [varchar](64) NULL,
	[service_id] [varchar](64) NULL,
 CONSTRAINT [secure_column_algorithm_info_pk] PRIMARY KEY CLUSTERED 
(
	[owner] ASC,
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_column_algorithm_info] ADD  CONSTRAINT [df_secure_column_algorithm_info_stat_cd]  DEFAULT ('P') FOR [stat_cd]
GO
