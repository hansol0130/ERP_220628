USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_kms_service_column](
	[service_id] [varchar](64) NOT NULL,
	[db_name] [varchar](64) NOT NULL,
	[db_owner] [varchar](128) NOT NULL,
	[db_table] [varchar](128) NOT NULL,
	[db_column] [varchar](128) NOT NULL,
	[key_id] [varchar](64) NOT NULL,
	[pid_symm] [varchar](64) NULL,
	[pid_ape] [varchar](64) NULL,
	[pid_out] [varchar](64) NOT NULL,
	[pid_iv] [varchar](64) NOT NULL,
	[descript] [varchar](64) NULL,
	[time] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
