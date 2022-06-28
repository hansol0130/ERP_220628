USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL_SELL_POINT](
	[PRO_CODE] [varchar](20) NOT NULL,
	[TRAFFIC_POINT] [varchar](800) NULL,
	[STAY_POINT] [varchar](800) NULL,
	[TOUR_POINT] [varchar](800) NULL,
	[EAT_POINT] [varchar](800) NULL,
	[DISCOUNT_POINT] [varchar](800) NULL,
	[OTHER_POINT] [varchar](800) NULL,
	[INNER_PKG_GUIDANCE] [varchar](max) NULL,
	[INNER_CONTENT_URL] [varchar](max) NULL,
 CONSTRAINT [PK_PKG_DETAIL_SELL_POINT] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_DETAIL_SELL_POINT]  WITH CHECK ADD  CONSTRAINT [R_63] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[PKG_DETAIL] ([PRO_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_DETAIL_SELL_POINT] CHECK CONSTRAINT [R_63]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교통포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'TRAFFIC_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'STAY_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관광포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'TOUR_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식사포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'EAT_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인/증정포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'DISCOUNT_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'OTHER_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사상품셀링가이드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'INNER_PKG_GUIDANCE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사상품셀링포인트파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT', @level2type=N'COLUMN',@level2name=N'INNER_CONTENT_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SELL_POINT'
GO
