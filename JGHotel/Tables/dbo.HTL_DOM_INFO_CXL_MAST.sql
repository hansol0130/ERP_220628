USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_DOM_INFO_CXL_MAST](
	[CX_SEQ] [int] NOT NULL,
	[HOTEL_CODE] [varchar](10) NULL,
	[ROOM_CODE] [varchar](500) NULL,
	[DATE_FROM] [datetime] NULL,
	[DATE_TO] [datetime] NULL,
	[SORT_ORDER] [int] NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_USER] [varchar](30) NULL,
	[CREATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL
) ON [PRIMARY]
GO
