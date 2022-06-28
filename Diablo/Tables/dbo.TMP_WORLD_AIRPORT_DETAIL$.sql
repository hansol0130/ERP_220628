USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_WORLD_AIRPORT_DETAIL$](
	[Airport ID] [float] NULL,
	[Name] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[IATA_FAA] [nvarchar](255) NULL,
	[ICAO] [nvarchar](255) NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[Altitude] [float] NULL,
	[Timezone] [float] NULL,
	[DST] [nvarchar](255) NULL,
	[Tz_database_time_zone  ] [nvarchar](255) NULL
) ON [PRIMARY]
GO
