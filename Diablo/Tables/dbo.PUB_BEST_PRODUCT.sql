USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_BEST_PRODUCT](
	[PRO_TYPE] [varchar](2) NOT NULL,
	[A_TYPE] [varchar](2) NOT NULL,
	[B_TYPE] [varchar](2) NOT NULL,
	[C_TYPE] [varchar](2) NOT NULL,
	[REG_SEQ] [int] NOT NULL,
	[CODE_TYPE] [int] NULL,
	[CODE] [varchar](20) NULL,
	[PRICE_SEQ] [int] NULL,
	[DEFAULT_PRICE] [int] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[PKG_NAME] [dbo].[PRO_NAME] NULL,
 CONSTRAINT [PK_PUB_BEST_PRODUCT] PRIMARY KEY CLUSTERED 
(
	[PRO_TYPE] ASC,
	[A_TYPE] ASC,
	[B_TYPE] ASC,
	[C_TYPE] ASC,
	[REG_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_BEST_PRODUCT]  WITH NOCHECK ADD  CONSTRAINT [R_304] FOREIGN KEY([PRO_TYPE], [A_TYPE], [B_TYPE], [C_TYPE])
REFERENCES [dbo].[PUB_BEST] ([PRO_TYPE], [A_TYPE], [B_TYPE], [C_TYPE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_BEST_PRODUCT] CHECK CONSTRAINT [R_304]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'A_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'중분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'B_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'C_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'REG_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드구분  ( 1 : 마스터코드, 2 : 행사코드 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'CODE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기본가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'DEFAULT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT', @level2type=N'COLUMN',@level2name=N'PKG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트등록상품' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_PRODUCT'
GO
