USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_HOTEL](
	[mstCode] [varchar](20) NULL,
	[childCode] [varchar](30) NULL,
	[dayTotal] [int] NULL,
	[day] [int] NULL,
	[eat_breakfast] [varchar](10) NOT NULL,
	[eat_breakfastText] [varchar](500) NULL,
	[eat_lunch] [varchar](10) NOT NULL,
	[eat_lunchText] [varchar](500) NULL,
	[eat_dinner] [varchar](10) NOT NULL,
	[eat_dinnerText] [varchar](500) NULL,
	[stay_hotelPoiID] [varchar](500) NOT NULL,
	[stay_text] [nvarchar](1000) NULL,
	[HTL_MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[HOTEL_NAME] [nvarchar](500) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'mstCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'childCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총숙박일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'dayTotal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'day'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조식식사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'eat_breakfast'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조식식사비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'eat_breakfastText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'중식식사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'eat_lunch'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'중식식사비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'eat_lunchText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'석식식사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'eat_dinner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'석식식사비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'eat_dinnerText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박호텔ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'stay_hotelPoiID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'stay_text'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'HTL_MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL', @level2type=N'COLUMN',@level2name=N'HOTEL_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버자상품호텔' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_HOTEL'
GO
