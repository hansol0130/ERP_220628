USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BOARD_CODE](
	[BD_CODE] [int] NOT NULL,
	[BD_TYPE] [varchar](4) NULL,
	[BD_NAME] [varchar](300) NULL,
	[REPLY_YN] [varchar](1) NULL,
	[DOC_YN] [varchar](1) NULL,
	[CMT_YN] [varchar](1) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL
) ON [PRIMARY]
GO
