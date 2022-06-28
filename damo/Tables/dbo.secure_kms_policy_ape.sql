USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_kms_policy_ape](
	[pid_ape] [varchar](64) NOT NULL,
	[ape_algo_type] [int] NOT NULL,
	[ape_mode] [int] NULL,
	[ape_type] [int] NULL,
	[ignore_symbols] [varchar](256) NULL,
	[in_symbols] [varchar](256) NULL,
	[out_symbols] [varchar](256) NULL,
	[ope_max_byte] [int] NULL,
	[descript] [varchar](64) NULL,
	[time] [varchar](20) NULL,
	[iv_type] [int] NULL,
	[replace_in] [varchar](256) NULL,
	[replace_out] [varchar](256) NULL,
	[in_multiset] [int] NULL,
	[out_multiset] [int] NULL,
	[null_enc] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[pid_ape] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
