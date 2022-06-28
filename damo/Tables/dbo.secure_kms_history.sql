USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_kms_history](
	[id] [int] NULL,
	[key_id] [varchar](64) NULL,
	[key_data] [varchar](1024) NULL,
	[key_len] [int] NULL,
	[key_type] [int] NULL,
	[pid_symm] [varchar](64) NULL,
	[symm_algo_type] [int] NULL,
	[policy_key_len] [int] NULL,
	[op_mode_type] [int] NULL,
	[policy_iv_type] [int] NULL,
	[auth_data] [varchar](64) NULL,
	[out_type] [int] NULL,
	[dupl_enc_data] [varchar](32) NULL,
	[padding] [int] NULL,
	[null_enc] [int] NULL,
	[pid_ape] [varchar](64) NULL,
	[ape_algo_type] [int] NULL,
	[ape_mode] [int] NULL,
	[ape_type] [int] NULL,
	[ignore_symbols] [varchar](256) NULL,
	[in_symbols] [varchar](256) NULL,
	[out_symbols] [varchar](256) NULL,
	[ope_max_byte] [int] NULL,
	[ape_iv_type] [int] NULL,
	[replace_in] [varchar](256) NULL,
	[replace_out] [varchar](256) NULL,
	[in_multiset] [int] NULL,
	[out_multiset] [int] NULL,
	[pid_out] [varchar](64) NULL,
	[range_start] [int] NULL,
	[range_len] [int] NULL,
	[enc_range_type] [int] NULL,
	[pid_iv] [varchar](64) NULL,
	[iv_type] [int] NULL,
	[iv_value] [varchar](64) NULL,
	[service_id] [varchar](64) NULL,
	[db_name] [varchar](64) NULL,
	[db_owner] [varchar](128) NULL,
	[db_table] [varchar](128) NULL,
	[db_column] [varchar](128) NULL,
	[service_key_id] [varchar](64) NULL,
	[service_pid_symm] [varchar](64) NULL,
	[service_pid_ape] [varchar](64) NULL,
	[service_pid_out] [varchar](64) NULL,
	[service_pid_iv] [varchar](64) NULL
) ON [PRIMARY]
GO
