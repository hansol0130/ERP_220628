USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_CITY_CODE_TMP](
	[N_CITY_CODE] [nvarchar](255) NULL,
	[NAME_KR] [nvarchar](255) NULL,
	[NAME_EN] [nvarchar](255) NULL,
	[N_NATION_CODE] [nvarchar](255) NULL,
	[N_NATION_NAME] [nvarchar](255) NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
