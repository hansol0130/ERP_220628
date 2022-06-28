USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL_PRICE_GROUP_COST](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[PRICE_SEQ] [int] NOT NULL,
	[COST_SEQ] [int] NOT NULL,
	[COST_NAME] [varchar](20) NULL,
	[CURRENCY] [varchar](3) NULL,
	[ADT_COST] [int] NULL,
	[CHD_COST] [int] NULL,
	[INF_COST] [int] NULL,
	[USE_YN] [char](1) NULL,
 CONSTRAINT [PK_PKG_DETAIL_PRICE_GROUP_COST] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[PRICE_SEQ] ASC,
	[COST_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_DETAIL_PRICE_GROUP_COST]  WITH CHECK ADD  CONSTRAINT [R_421] FOREIGN KEY([PRO_CODE], [PRICE_SEQ])
REFERENCES [dbo].[PKG_DETAIL_PRICE] ([PRO_CODE], [PRICE_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_DETAIL_PRICE_GROUP_COST] CHECK CONSTRAINT [R_421]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비용순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'COST_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비용명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'COST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'CURRENCY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인비용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'ADT_COST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동비용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'CHD_COST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아비용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'INF_COST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사정보공동경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_PRICE_GROUP_COST'
GO
