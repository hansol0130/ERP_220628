USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_manage_user_info](
	[name_type] [varchar](8) NOT NULL,
	[type] [varchar](8) NOT NULL,
	[name] [varchar](256) NOT NULL,
	[createdate] [datetime] NULL,
 CONSTRAINT [secure_manage_user_info_pk] PRIMARY KEY CLUSTERED 
(
	[name_type] ASC,
	[type] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_manage_user_info] ADD  DEFAULT (getdate()) FOR [createdate]
GO
