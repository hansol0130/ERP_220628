USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weatheri_gtsworldlist](
	[대륙코드] [nvarchar](255) NULL,
	[W_CITY_CODE] [nvarchar](255) NULL,
	[위도] [nvarchar](255) NULL,
	[경도] [nvarchar](255) NULL,
	[W_CITY_ENG_NAME] [nvarchar](255) NULL,
	[W_CITY_KOR_NAME] [nvarchar](255) NULL,
	[W_NATION_CODE] [nvarchar](255) NULL,
	[W_NATION_KOR_NAME] [nvarchar](255) NULL,
	[W_NATION_ENG_NAME] [nvarchar](255) NULL,
	[W_REGION_KOR_NAME] [nvarchar](255) NULL,
	[W_REGION_ENG_NAME] [nvarchar](255) NULL,
	[UTC] [nvarchar](255) NULL,
	[SUMMER TIME] [nvarchar](255) NULL,
	[써머타임 시작] [nvarchar](255) NULL,
	[써머타임 종료] [nvarchar](255) NULL,
	[F16] [nvarchar](255) NULL
) ON [PRIMARY]
GO
