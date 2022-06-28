USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_script](
	[owner] [varchar](256) NOT NULL,
	[table_name] [varchar](512) NOT NULL,
	[id] [varchar](32) NOT NULL,
	[row] [int] IDENTITY(1,1) NOT NULL,
	[text] [varchar](4096) NOT NULL,
 CONSTRAINT [secure_script_pk] PRIMARY KEY CLUSTERED 
(
	[owner] ASC,
	[table_name] ASC,
	[id] ASC,
	[row] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
