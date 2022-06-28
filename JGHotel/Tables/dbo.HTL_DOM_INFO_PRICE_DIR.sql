USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_DOM_INFO_PRICE_DIR](
	[PRICE_SEQ] [bigint] IDENTITY(1,1) NOT NULL,
	[HOTEL_CODE] [varchar](10) NULL,
	[ROOM_CODE] [varchar](10) NULL,
	[ROOM_NAME] [varchar](300) NULL,
	[CHECK_IN_DATE] [varchar](10) NULL,
	[CURRENCY] [varchar](3) NULL,
	[NET_PRICE] [decimal](18, 0) NULL,
	[SALE_PRICE] [decimal](18, 0) NULL,
	[AVAIL_TYPE] [varchar](2) NULL,
	[HARD_TOTAL] [int] NULL,
	[SOFT_TOTAL] [int] NULL,
	[REQ_TOTAL] [int] NULL,
	[HARD_USED] [int] NULL,
	[SOFT_USED] [int] NULL,
	[REQ_USED] [int] NULL,
	[HARD_REMAIN] [int] NULL,
	[SOFT_REMAIN] [int] NULL,
	[REQ_REMAIN] [int] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[CREATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL
) ON [PRIMARY]
GO
