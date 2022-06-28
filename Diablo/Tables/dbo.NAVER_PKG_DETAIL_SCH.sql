USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_SCH](
	[mstCode] [varchar](20) NULL,
	[childCode] [varchar](30) NULL,
	[day] [int] NULL,
	[index] [bigint] NULL,
	[title] [nvarchar](500) NULL,
	[spotPoiID] [varchar](30) NULL,
	[imageUrl] [varchar](500) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[PRICE_SEQ] [int] NULL,
	[SCH_SEQ] [int] NULL,
	[DAY_NUMBER] [int] NULL,
	[CITY_NAME] [nvarchar](200) NULL,
	[CNT_CODE] [int] NULL,
	[CNT_INFO] [nvarchar](max) NULL,
	[CITY_CODE] [varchar](3) NULL,
	[N_CITY_CODE] [varchar](3) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'mstCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'childCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일차순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'day'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'index'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'명소ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'spotPoiID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'imageUrl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'SCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일차' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'DAY_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'CITY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'CNT_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH', @level2type=N'COLUMN',@level2name=N'N_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버자상품일정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH'
GO
