USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_CONNECT](
	[MASTER_CODE] [varchar](10) NULL,
	[CON_TYPE] [varchar](2) NULL,
	[CON_MASTER_CODE] [varchar](10) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_CONNECT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'키 더미' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_CONNECT', @level2type=N'COLUMN',@level2name=N'CON_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상대 마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_CONNECT', @level2type=N'COLUMN',@level2name=N'CON_MASTER_CODE'
GO
