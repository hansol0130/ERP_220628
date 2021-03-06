USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_RESV_ROOM](
	[RESV_NO] [int] NOT NULL,
	[ROOM_NO] [int] NOT NULL,
	[PAX_CNT] [int] NULL,
	[ROOM_TYPE] [varchar](20) NULL,
	[ROOM_DESC] [varchar](300) NULL,
	[PROMO_DESC] [varchar](2000) NULL,
	[BED_TYPE] [varchar](300) NULL,
	[USE_YN] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
 CONSTRAINT [PK_HTL_RESV_ROOM] PRIMARY KEY CLUSTERED 
(
	[RESV_NO] ASC,
	[ROOM_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
