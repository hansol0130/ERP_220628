USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_SUMMARY](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[SEARCH_TYPE] [varchar](10) NOT NULL,
	[SEARCH_VALUE] [int] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SUMMARY', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발요일 W 상품속성 T 여행기간 D 상품가격 P 선호항공 A 호텔등급 G 출발지역 S 업데이트 E' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SUMMARY', @level2type=N'COLUMN',@level2name=N'SEARCH_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'검색값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SUMMARY', @level2type=N'COLUMN',@level2name=N'SEARCH_VALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터요약' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SUMMARY'
GO
