USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_function_mode](
	[owner] [varchar](128) NOT NULL,
	[table_name] [varchar](300) NOT NULL,
	[name] [varchar](128) NOT NULL,
	[type] [varchar](8) NOT NULL,
	[mode] [varchar](8) NOT NULL,
 CONSTRAINT [secure_function_mode_pk] PRIMARY KEY CLUSTERED 
(
	[owner] ASC,
	[table_name] ASC,
	[name] ASC,
	[type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
