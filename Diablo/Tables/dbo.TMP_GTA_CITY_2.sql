USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_GTA_CITY_2](
	[CITY_CODE] [varchar](5) NOT NULL,
	[CITY_NAME] [varchar](100) NULL,
	[NATION_CODE] [char](2) NULL,
	[MAPPING_CITY_CODE] [varchar](5) NULL,
 CONSTRAINT [PK_TMP_GTA_CITY_2] PRIMARY KEY CLUSTERED 
(
	[CITY_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
