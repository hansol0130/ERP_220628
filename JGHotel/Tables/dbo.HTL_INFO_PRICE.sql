USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_INFO_PRICE](
	[HOTEL_CODE] [int] NOT NULL,
	[SUPP_CODE] [varchar](2) NULL,
	[ROOM_NAME] [varchar](300) NULL,
	[SALE_AMT] [decimal](18, 0) NULL,
	[CHECK_IN_DATE] [datetime] NULL,
	[CREATE_DATE] [datetime] NULL,
	[UPDATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_HTL_INFO_PRICE] PRIMARY KEY CLUSTERED 
(
	[HOTEL_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO