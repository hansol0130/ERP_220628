USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_SELL_POINT](
	[MASTER_CODE] [varchar](10) NOT NULL,
	[TRAFFIC_POINT] [varchar](800) NULL,
	[STAY_POINT] [varchar](800) NULL,
	[TOUR_POINT] [varchar](800) NULL,
	[EAT_POINT] [varchar](800) NULL,
	[DISCOUNT_POINT] [varchar](800) NULL,
	[OTHER_POINT] [varchar](800) NULL,
 CONSTRAINT [PK_PKG_MASTER_SELL_POINT] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SELL_POINT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교통포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SELL_POINT', @level2type=N'COLUMN',@level2name=N'TRAFFIC_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SELL_POINT', @level2type=N'COLUMN',@level2name=N'STAY_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관광포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SELL_POINT', @level2type=N'COLUMN',@level2name=N'TOUR_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식사포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SELL_POINT', @level2type=N'COLUMN',@level2name=N'EAT_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인/증정포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SELL_POINT', @level2type=N'COLUMN',@level2name=N'DISCOUNT_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SELL_POINT', @level2type=N'COLUMN',@level2name=N'OTHER_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SELL_POINT'
GO
