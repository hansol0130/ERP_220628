USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_SHOPPING](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[SHOP_SEQ] [int] NOT NULL,
	[SHOP_NAME] [varchar](30) NULL,
	[SHOP_PLACE] [varchar](30) NULL,
	[SHOP_TIME] [varchar](30) NULL,
	[SHOP_REMARK] [varchar](50) NULL,
 CONSTRAINT [PK_PKG_MASTER_SHOPPING] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[SHOP_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_SHOPPING]  WITH CHECK ADD  CONSTRAINT [R_422] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_MASTER_SHOPPING] CHECK CONSTRAINT [R_422]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SHOPPING', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑품목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑장소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_PLACE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소요시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SHOPPING', @level2type=N'COLUMN',@level2name=N'SHOP_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터 쇼핑정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SHOPPING'
GO
