USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_user_info](
	[user_name] [varchar](255) NOT NULL,
	[user_pass] [varchar](256) NULL,
	[user_kind] [int] NULL,
	[user_status] [int] NULL,
	[created] [datetime] NOT NULL,
	[modified] [datetime] NOT NULL,
 CONSTRAINT [secure_user_info_pk] PRIMARY KEY CLUSTERED 
(
	[user_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_user_info] ADD  CONSTRAINT [df__secure_us__creat__7ef6d905]  DEFAULT (getdate()) FOR [created]
GO
ALTER TABLE [dbo].[secure_user_info] ADD  CONSTRAINT [df__secure_us__modif__7feafd3e]  DEFAULT (getdate()) FOR [modified]
GO
