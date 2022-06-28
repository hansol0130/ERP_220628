USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_algorithm](
	[id] [int] NOT NULL,
	[cis_asn] [varchar](64) NOT NULL,
	[key_size] [int] NOT NULL,
	[iv_size] [int] NOT NULL,
	[block_size] [int] NOT NULL,
	[display] [varchar](64) NOT NULL,
	[algo_desc] [varchar](256) NULL,
	[resourceid] [int] NOT NULL,
	[flag] [char](1) NOT NULL,
 CONSTRAINT [secure_secure_algorithm_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[cis_asn] ASC,
	[display] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_algorithm] ADD  DEFAULT ((1902)) FOR [resourceid]
GO
ALTER TABLE [dbo].[secure_algorithm]  WITH CHECK ADD  CONSTRAINT [secure_algorithm_flag_check] CHECK  (([flag]='A' OR [flag]='N'))
GO
ALTER TABLE [dbo].[secure_algorithm] CHECK CONSTRAINT [secure_algorithm_flag_check]
GO
