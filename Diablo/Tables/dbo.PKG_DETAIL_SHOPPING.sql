USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL_SHOPPING](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[SHOP_SEQ] [int] NOT NULL,
	[SHOP_NAME] [varchar](30) NULL,
	[SHOP_PLACE] [varchar](30) NULL,
	[SHOP_TIME] [varchar](30) NULL,
	[SHOP_REMARK] [varchar](50) NULL,
 CONSTRAINT [PK_PKG_DETAIL_SHOPPING] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[SHOP_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_DETAIL_SHOPPING]  WITH CHECK ADD  CONSTRAINT [R_423] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[PKG_DETAIL] ([PRO_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_DETAIL_SHOPPING] CHECK CONSTRAINT [R_423]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SHOPPING', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑품목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑장소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_PLACE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소요시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사정보 쇼핑정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SHOPPING'
GO
