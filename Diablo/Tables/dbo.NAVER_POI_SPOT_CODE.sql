USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_POI_SPOT_CODE](
	[N_CNT_CODE] [varchar](30) NULL,
	[NAME_KR] [nvarchar](100) NULL,
	[NAME_EN] [nvarchar](100) NULL,
	[CITY_ID] [float] NULL,
	[CITY_NAME_KR] [nvarchar](100) NULL,
	[CITY_NAME_EN] [nvarchar](100) NULL,
	[N_CITY_CODE] [varchar](3) NULL,
	[N_NATION_CODE] [nvarchar](2) NULL,
	[NATION_NAME_KR] [nvarchar](100) NULL,
	[NATION_NAME_EN] [nvarchar](100) NULL,
	[CITY_CODE] [varchar](3) NULL,
	[CHK_DATE] [datetime] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버명소코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'N_CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'NAME_KR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'NAME_EN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'CITY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시한글명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'CITY_NAME_KR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시영문명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'CITY_NAME_EN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'N_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'N_NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가한글명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'NATION_NAME_KR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가영문명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'NATION_NAME_EN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체크일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE', @level2type=N'COLUMN',@level2name=N'CHK_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버명소코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_POI_SPOT_CODE'
GO
