USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_OPTION](
	[mstCode] [varchar](20) NULL,
	[childCode] [varchar](30) NULL,
	[opt_seq] [int] NOT NULL,
	[opt_name] [nvarchar](200) NULL,
	[opt_price] [int] NULL,
	[opt_currency] [varchar](3) NULL,
	[opt_descriptions] [nvarchar](300) NULL,
	[opt_taketime] [nvarchar](120) NULL,
	[isUseGuide] [varchar](5) NOT NULL,
	[opt_absentDescriptions] [nvarchar](800) NULL,
	[OPT_COMPANION] [nvarchar](120) NULL,
	[OPT_PRICE_TXT] [varchar](120) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'mstCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'childCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'opt_seq'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'opt_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'opt_price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광경비통화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'opt_currency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'opt_descriptions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'opt_taketime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가이드유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'isUseGuide'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광비선택일정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'opt_absentDescriptions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광동행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_COMPANION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광가격텍스트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_PRICE_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버자상품선택관광' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_OPTION'
GO
