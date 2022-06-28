USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_MASTER](
	[mstCode] [varchar](20) NULL,
	[mstTitle] [nvarchar](4000) NULL,
	[imageUrl] [varchar](300) NULL,
	[createdDate] [varchar](19) NULL,
	[updateDate] [datetime] NULL,
	[updateChildCount] [int] NULL,
	[useYn] [varchar](1) NULL,
	[productFamilyRank] [int] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER', @level2type=N'COLUMN',@level2name=N'mstCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER', @level2type=N'COLUMN',@level2name=N'mstTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품대표이미지 URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER', @level2type=N'COLUMN',@level2name=N'imageUrl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER', @level2type=N'COLUMN',@level2name=N'createdDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER', @level2type=N'COLUMN',@level2name=N'updateDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정된자상품수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER', @level2type=N'COLUMN',@level2name=N'updateChildCount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER', @level2type=N'COLUMN',@level2name=N'useYn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품노출순위' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER', @level2type=N'COLUMN',@level2name=N'productFamilyRank'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버모상품' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_MASTER'
GO
