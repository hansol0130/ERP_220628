USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_kms_key_symm](
	[key_id] [varchar](64) NOT NULL,
	[key_data] [varchar](1024) NULL,
	[key_len] [int] NOT NULL,
	[key_type] [int] NOT NULL,
	[descript] [varchar](64) NULL,
	[time] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[key_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
