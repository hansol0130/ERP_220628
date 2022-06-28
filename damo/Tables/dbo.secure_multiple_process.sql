USE [damo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[secure_multiple_process](
	[group_id] [int] NOT NULL,
	[procedure_name] [varchar](300) NOT NULL,
	[stat_cd] [char](1) NOT NULL,
	[cancel_cd] [char](1) NULL,
	[type_cd] [char](1) NULL,
	[reg_dt] [varchar](20) NULL
) ON [PRIMARY]
GO
