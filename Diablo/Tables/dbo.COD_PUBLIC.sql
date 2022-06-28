USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COD_PUBLIC](
	[PUB_TYPE] [dbo].[PUB_TYPE] NOT NULL,
	[PUB_CODE] [dbo].[PUB_CODE] NOT NULL,
	[PUB_VALUE] [varchar](50) NULL,
	[PUB_VALUE2] [varchar](100) NULL,
	[USE_YN] [char](1) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_PUBLIC', @level2type=N'COLUMN',@level2name=N'PUB_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공용코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_PUBLIC', @level2type=N'COLUMN',@level2name=N'PUB_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'값1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_PUBLIC', @level2type=N'COLUMN',@level2name=N'PUB_VALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'값2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_PUBLIC', @level2type=N'COLUMN',@level2name=N'PUB_VALUE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_PUBLIC', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공용테이블' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COD_PUBLIC'
GO
