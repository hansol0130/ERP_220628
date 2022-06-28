USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GTA_CITY](
	[Seq] [int] NULL,
	[CityCode] [char](3) NOT NULL,
	[CoCityCode] [varchar](5) NOT NULL,
	[CoCityName] [varchar](100) NULL,
	[Cooperation] [varchar](2) NOT NULL
) ON [PRIMARY]
GO
