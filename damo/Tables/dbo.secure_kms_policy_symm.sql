USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_kms_policy_symm](
	[pid_symm] [varchar](64) NOT NULL,
	[symm_algo_type] [int] NOT NULL,
	[key_len] [int] NOT NULL,
	[op_mode_type] [int] NOT NULL,
	[iv_type] [int] NOT NULL,
	[auth_data] [varchar](64) NULL,
	[descript] [varchar](64) NULL,
	[time] [varchar](20) NULL,
	[out_type] [int] NULL,
	[dupl_enc_data] [varchar](32) NULL,
	[padding] [int] NULL,
	[null_enc] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[pid_symm] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
