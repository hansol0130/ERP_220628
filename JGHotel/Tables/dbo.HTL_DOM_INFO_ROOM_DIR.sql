USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_DOM_INFO_ROOM_DIR](
	[HOTEL_CODE] [varchar](10) NOT NULL,
	[ROOM_CODE] [varchar](10) NOT NULL,
	[ROOM_TYPE_CODE] [varchar](50) NULL,
	[ROOM_NAME] [varchar](300) NULL,
	[ROOM_DESC] [varchar](4000) NULL,
	[ROOM_CNT] [smallint] NULL,
	[MIN_PAX_CNT] [smallint] NULL,
	[MAX_PAX_CNT] [smallint] NULL,
	[MEAL_YN] [varchar](1) NULL,
	[ROOM_ORDER] [int] NULL,
	[ROOM_USE_YN] [varchar](1) NULL,
	[CREATE_USER] [varchar](30) NULL,
	[CREATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[AFF_INCL] [varchar](500) NULL
) ON [PRIMARY]
GO
