USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_priv_template_detail](
	[priv_id] [int] IDENTITY(1,1) NOT NULL,
	[ip_info] [varchar](4000) NULL,
	[mac_info] [varchar](512) NULL,
	[service_info] [varchar](256) NULL,
	[osuser_info] [varchar](256) NULL,
	[time_info] [varchar](256) NULL,
	[flag] [varchar](256) NULL,
	[use_acl] [varchar](16) NULL,
	[template_id] [int] NOT NULL,
	[comments] [varchar](1024) NULL,
 CONSTRAINT [sys_c005462] PRIMARY KEY CLUSTERED 
(
	[priv_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_priv_template_detail]  WITH CHECK ADD  CONSTRAINT [sys_c005463] FOREIGN KEY([template_id])
REFERENCES [dbo].[secure_priv_template] ([template_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[secure_priv_template_detail] CHECK CONSTRAINT [sys_c005463]
GO
