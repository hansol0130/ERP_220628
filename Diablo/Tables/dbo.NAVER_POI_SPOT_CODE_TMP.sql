USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_POI_SPOT_CODE_TMP](
	[SPOT_ID] [nvarchar](255) NULL,
	[NAMEKR] [nvarchar](255) NULL,
	[NAMEEN] [nvarchar](255) NULL,
	[CITY_CODE] [nvarchar](255) NULL,
	[NATION_CODE] [nvarchar](255) NULL,
	[CITY_NAME] [nvarchar](255) NULL,
	[NATION_NAME] [nvarchar](255) NULL,
	[NEW_dATE] [datetime] NULL
) ON [PRIMARY]
GO
