USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_MASTER](
	[APP_CODE] [int] NOT NULL,
	[APP_NAME] [varchar](50) NULL,
	[APP_OS] [varchar](20) NULL,
 CONSTRAINT [XPKAPP_MASTER] PRIMARY KEY CLUSTERED 
(
	[APP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'앱코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MASTER', @level2type=N'COLUMN',@level2name=N'APP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'앱명칭' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MASTER', @level2type=N'COLUMN',@level2name=N'APP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'앱OS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MASTER', @level2type=N'COLUMN',@level2name=N'APP_OS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'앱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MASTER'
GO
