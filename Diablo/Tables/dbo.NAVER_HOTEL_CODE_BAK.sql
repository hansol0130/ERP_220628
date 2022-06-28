USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_HOTEL_CODE_BAK](
	[HotelID] [float] NULL,
	[HotelName_EN] [nvarchar](255) NULL,
	[HotelName_KR] [nvarchar](255) NULL,
	[StarRating] [float] NULL,
	[CountryCode] [nvarchar](255) NULL,
	[CountryName] [nvarchar](255) NULL,
	[PlaceName_EN] [nvarchar](255) NULL,
	[PlaceName_KR] [nvarchar](255) NULL,
	[HotelAddress_EN] [nvarchar](255) NULL,
	[Naver Hotel Link] [nvarchar](255) NULL,
	[F11] [nvarchar](255) NULL
) ON [PRIMARY]
GO
