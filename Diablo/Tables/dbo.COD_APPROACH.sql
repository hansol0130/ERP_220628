USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COD_APPROACH](
	[GRP_CODE] [varchar](10) NOT NULL,
	[SEARCH_WORD] [varchar](100) NOT NULL,
	[RESULT_WORD] [varchar](5) NOT NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_APPROACH', @level2type=N'COLUMN',@level2name=N'GRP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'근접어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_APPROACH', @level2type=N'COLUMN',@level2name=N'SEARCH_WORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'검색어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_APPROACH', @level2type=N'COLUMN',@level2name=N'RESULT_WORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'근접어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_APPROACH'
GO
