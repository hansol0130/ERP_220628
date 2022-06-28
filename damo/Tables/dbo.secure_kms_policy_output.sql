USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_kms_policy_output](
	[pid_out] [varchar](64) NOT NULL,
	[range_start] [int] NULL,
	[range_len] [int] NULL,
	[enc_range_type] [int] NULL,
	[descript] [varchar](64) NULL,
	[time] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[pid_out] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
