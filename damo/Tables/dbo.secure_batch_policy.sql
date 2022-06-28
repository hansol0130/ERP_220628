USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_batch_policy](
	[pid] [varchar](128) NOT NULL,
	[algorithm] [int] NOT NULL,
	[op_mode] [int] NOT NULL,
	[iv_type] [int] NOT NULL,
	[select_type] [int] NOT NULL,
	[partial] [varchar](32) NULL,
	[is_index] [varchar](32) NULL,
	[key] [varchar](1024) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
