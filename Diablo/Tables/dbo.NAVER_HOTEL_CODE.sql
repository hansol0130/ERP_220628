USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_HOTEL_CODE](
	[N_HOTEL_ID] [int] NULL,
	[HOTEL_NAME_EN] [nvarchar](255) NULL,
	[HOTEL_NAME_KR] [nvarchar](255) NULL,
	[STAR_RATING] [float] NULL,
	[N_NATION_CODE] [nvarchar](5) NULL,
	[N_NATION_NAME] [nvarchar](255) NULL,
	[PLACENAME_EN] [nvarchar](255) NULL,
	[PLACENAME_KR] [nvarchar](255) NULL,
	[ADDRESS_EN] [nvarchar](255) NULL,
	[NAVER_LINK] [nvarchar](255) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[CHK_DATE] [datetime] NULL
) ON [PRIMARY]
GO
