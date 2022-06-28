USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_PRICE_DHS_MASTER](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[PRICE_SEQ] [int] NOT NULL,
	[DHS_ROOM_CODE] [varchar](20) NULL,
	[ADT_MAX_COUNT] [int] NULL,
	[CHD_MAX_COUNT] [int] NULL,
	[SALE_COM_CODE] [varchar](10) NULL,
	[COMM_RATE] [decimal](4, 2) NULL,
 CONSTRAINT [PK_PKG_MASTER_PRICE_DHS_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[PRICE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_PRICE_DHS_MASTER]  WITH CHECK ADD  CONSTRAINT [R_567] FOREIGN KEY([MASTER_CODE], [PRICE_SEQ])
REFERENCES [dbo].[PKG_MASTER_PRICE] ([MASTER_CODE], [PRICE_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_MASTER_PRICE_DHS_MASTER] CHECK CONSTRAINT [R_567]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_DHS_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_DHS_MASTER', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸타입 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_DHS_MASTER', @level2type=N'COLUMN',@level2name=N'DHS_ROOM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대 투숙가능 성인 수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_DHS_MASTER', @level2type=N'COLUMN',@level2name=N'ADT_MAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대 투숙가능 아동 수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_DHS_MASTER', @level2type=N'COLUMN',@level2name=N'CHD_MAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_DHS_MASTER', @level2type=N'COLUMN',@level2name=N'SALE_COM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매수수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_DHS_MASTER', @level2type=N'COLUMN',@level2name=N'COMM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국내호텔홈쇼핑마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PRICE_DHS_MASTER'
GO
