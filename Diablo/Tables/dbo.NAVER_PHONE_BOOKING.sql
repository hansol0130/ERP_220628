USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PHONE_BOOKING](
	[CONSULT_RES_SEQ] [int] NOT NULL,
	[NAVER_RES_KEY] [varchar](10) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[PRICE_SEQ] [int] NULL,
	[ADT_COUNT] [int] NULL,
	[CHD_COUNT] [int] NULL,
	[INF_COUNT] [int] NULL,
 CONSTRAINT [PK_NAVER_PHONE_BOOKING] PRIMARY KEY CLUSTERED 
(
	[CONSULT_RES_SEQ] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객약속순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PHONE_BOOKING', @level2type=N'COLUMN',@level2name=N'CONSULT_RES_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버예약키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PHONE_BOOKING', @level2type=N'COLUMN',@level2name=N'NAVER_RES_KEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PHONE_BOOKING', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PHONE_BOOKING', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PHONE_BOOKING', @level2type=N'COLUMN',@level2name=N'ADT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PHONE_BOOKING', @level2type=N'COLUMN',@level2name=N'CHD_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소아수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PHONE_BOOKING', @level2type=N'COLUMN',@level2name=N'INF_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버상담예약' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PHONE_BOOKING'
GO
