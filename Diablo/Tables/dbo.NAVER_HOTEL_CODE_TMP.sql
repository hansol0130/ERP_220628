USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_HOTEL_CODE_TMP](
	[N_HOTEL_ID] [float] NULL,
	[HOTEL_NAME_EN] [nvarchar](255) NULL,
	[HOTEL_NAME_KR] [nvarchar](255) NULL,
	[STAR_RATING] [float] NULL,
	[N_NATION_CODE] [nvarchar](255) NULL,
	[N_NATION_NAME] [nvarchar](255) NULL,
	[N_CITY_CODE] [nvarchar](255) NULL,
	[PLACENAME_EN] [nvarchar](255) NULL,
	[PLACENAME_KR] [nvarchar](255) NULL,
	[ADDRESS_EN] [nvarchar](255) NULL,
	[NEW_dATE] [datetime] NULL
) ON [PRIMARY]
GO
