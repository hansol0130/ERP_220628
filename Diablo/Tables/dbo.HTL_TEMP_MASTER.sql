USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_TEMP_MASTER](
	[HotelId] [int] NOT NULL,
	[HotelName] [nvarchar](100) NULL,
	[CheckIn] [int] NULL,
	[CheckOut] [int] NULL,
	[Rooms] [int] NULL,
	[ThumbPath] [varchar](200) NULL,
	[ShortDescription] [nvarchar](1000) NULL,
	[LongDescription] [nvarchar](max) NULL,
	[HotelCurrency] [varchar](3) NULL,
	[Address] [nvarchar](100) NULL,
	[Zip] [varchar](20) NULL,
	[Latitude] [decimal](8, 5) NULL,
	[Longitude] [decimal](8, 5) NULL,
	[City] [nvarchar](50) NULL,
	[CityCode] [varchar](3) NULL,
	[Location] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[StateCode] [varchar](4) NULL,
	[CountryCode] [varchar](5) NULL,
	[Stars] [decimal](2, 1) NULL,
	[Phone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[AirportCode] [varchar](5) NULL,
	[RefDirection] [varchar](5) NULL,
	[RefPointDist] [varchar](10) NULL,
	[DistUnit] [varchar](10) NULL,
	[TimeStamp] [datetime] NULL,
 CONSTRAINT [PK_HTL_TEMP_MASTER] PRIMARY KEY CLUSTERED 
(
	[HotelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
