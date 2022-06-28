USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_kms_policy_iv](
	[pid_iv] [varchar](64) NOT NULL,
	[iv_type] [int] NULL,
	[iv_value] [varchar](64) NULL,
	[descript] [varchar](64) NULL,
	[time] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[pid_iv] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
