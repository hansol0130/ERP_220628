USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_job_info](
	[group_id] [int] NOT NULL,
	[work_id] [int] NOT NULL,
	[owner] [varchar](128) NOT NULL,
	[table_name] [varchar](300) NOT NULL,
	[column_name] [varchar](5120) NOT NULL,
	[cdate] [datetime] NOT NULL,
	[ctime] [char](8) NULL,
	[job_stat] [char](1) NULL,
	[error_code] [int] NULL,
	[error_msg] [varchar](1024) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[secure_job_info] ADD  CONSTRAINT [df__secure_jo__job_s__74794a92]  DEFAULT ('Y') FOR [job_stat]
GO
