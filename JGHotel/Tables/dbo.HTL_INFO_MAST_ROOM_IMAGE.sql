USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_INFO_MAST_ROOM_IMAGE](
	[IMG_NO] [int] NOT NULL,
	[HOTEL_CODE] [int] NULL,
	[ROOM_CODE] [int] NULL,
	[IMG_THUMB] [varchar](200) NULL,
	[IMG_URL] [varchar](200) NULL,
	[IMG_Z] [varchar](200) NULL,
 CONSTRAINT [PK_HTL_INFO_MAST_ROOM_IMAGE] PRIMARY KEY CLUSTERED 
(
	[IMG_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
