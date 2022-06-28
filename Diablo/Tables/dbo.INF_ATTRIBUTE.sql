USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_ATTRIBUTE](
	[CNT_ATT_CODE] [int] IDENTITY(1,1) NOT NULL,
	[CNT_ATT_NAME] [nvarchar](50) NULL,
	[PARENT_CODE] [int] NULL,
	[SHOW_YN] [char](1) NULL,
 CONSTRAINT [PK_INF_ATTRIBUTE] PRIMARY KEY CLUSTERED 
(
	[CNT_ATT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_ATTRIBUTE] ADD  CONSTRAINT [DF_INF_ATTRIBUTE_PARENT_CODE]  DEFAULT ((0)) FOR [PARENT_CODE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠타입코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'CNT_ATT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'CNT_ATT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상위컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'PARENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_ATTRIBUTE'
GO
