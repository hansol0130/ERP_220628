USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_policy_master](
	[sp_alias] [varchar](64) NOT NULL,
	[algorithm] [int] NULL,
	[op_mode] [int] NULL,
	[iv_type] [int] NULL,
	[select_type] [int] NULL,
	[key] [varchar](1024) NULL,
	[column_info] [varchar](12) NULL,
	[enc_range] [varchar](10) NULL,
	[enc_range_type] [varchar](5) NULL,
	[enc_null] [varchar](10) NULL,
	[reg_date] [datetime] NULL,
	[operator] [varchar](30) NULL,
	[comments] [varchar](2048) NULL,
	[service_id] [varchar](64) NOT NULL,
 CONSTRAINT [pk_secure_policy_master] PRIMARY KEY CLUSTERED 
(
	[sp_alias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
