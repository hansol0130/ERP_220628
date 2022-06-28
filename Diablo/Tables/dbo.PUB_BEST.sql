USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_BEST](
	[PRO_TYPE] [varchar](2) NOT NULL,
	[A_TYPE] [varchar](2) NOT NULL,
	[B_TYPE] [varchar](2) NOT NULL,
	[C_TYPE] [varchar](2) NOT NULL,
	[PRO_NAME] [varchar](50) NULL,
	[A_NAME] [varchar](50) NULL,
	[B_NAME] [varchar](50) NULL,
	[C_NAME] [varchar](50) NULL,
	[MAX_COUNT] [int] NULL,
 CONSTRAINT [PK_PUB_BEST] PRIMARY KEY CLUSTERED 
(
	[PRO_TYPE] ASC,
	[A_TYPE] ASC,
	[B_TYPE] ASC,
	[C_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'A_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'중분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'B_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소분류코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'C_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품분류명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대분류명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'A_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'중분류명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'B_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소분류명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'C_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대등록상품수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST', @level2type=N'COLUMN',@level2name=N'MAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트상품' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST'
GO
