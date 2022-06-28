USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAFE_INFO_NATION_CATEGORY_MAP](
	[SAFE_NATION_CODE] [varchar](3) NOT NULL,
	[SAFE_KOR_NAME] [varchar](50) NOT NULL,
	[SAFE_ENG_NAME] [varchar](50) NOT NULL,
	[NATION_CODE] [varchar](2) NULL,
	[KOR_NAME] [varchar](50) NULL,
	[ENG_NAME] [varchar](50) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'안전정보국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_NATION_CATEGORY_MAP', @level2type=N'COLUMN',@level2name=N'SAFE_NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'안전정보국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_NATION_CATEGORY_MAP', @level2type=N'COLUMN',@level2name=N'SAFE_KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'안전정보영문국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_NATION_CATEGORY_MAP', @level2type=N'COLUMN',@level2name=N'SAFE_ENG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_NATION_CATEGORY_MAP', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_NATION_CATEGORY_MAP', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_NATION_CATEGORY_MAP', @level2type=N'COLUMN',@level2name=N'ENG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가정보맵핑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_NATION_CATEGORY_MAP'
GO
