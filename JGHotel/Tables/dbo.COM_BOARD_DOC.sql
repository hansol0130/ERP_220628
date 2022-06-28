USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BOARD_DOC](
	[DOC_NO] [int] NOT NULL,
	[BD_NO] [int] NULL,
	[FILE_URL] [varchar](500) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL
) ON [PRIMARY]
GO
