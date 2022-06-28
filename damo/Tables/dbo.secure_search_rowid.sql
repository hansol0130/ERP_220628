USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_search_rowid](
	[owner] [varchar](128) NULL,
	[table_name] [varchar](300) NULL,
	[block_id] [varchar](30) NULL,
	[block_cnt] [int] NULL,
	[total_cnt] [int] NULL,
	[max_block] [varchar](30) NULL,
	[min_block] [varchar](30) NULL
) ON [PRIMARY]
GO
