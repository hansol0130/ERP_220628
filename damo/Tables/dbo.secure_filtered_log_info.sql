USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_filtered_log_info](
	[log_seq] [int] IDENTITY(1,1) NOT NULL,
	[owner] [varchar](256) NULL,
	[table_name] [varchar](512) NULL,
	[column_name] [varchar](256) NULL,
	[ip_info] [varchar](2048) NULL,
	[service_info] [varchar](512) NULL,
	[module_info] [varchar](512) NULL,
	[flag] [varchar](16) NULL,
	[comments] [varchar](1024) NULL,
 CONSTRAINT [pk_secure_filtered_log_info] PRIMARY KEY CLUSTERED 
(
	[log_seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
