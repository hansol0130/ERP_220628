USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_policy_priv_info](
	[user_name] [varchar](255) NOT NULL,
	[sp_alias] [varchar](64) NOT NULL,
	[context] [varchar](4000) NULL,
 CONSTRAINT [pk_secure_policy_priv_info] PRIMARY KEY CLUSTERED 
(
	[user_name] ASC,
	[sp_alias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
