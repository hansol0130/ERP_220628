USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_CATEGORY_MASTER](
	[CATEGORY_GROUP] [char](3) NOT NULL,
	[CATEGORY_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[SUBJECT] [varchar](70) NULL,
	[SORT] [int] NULL,
	[VIEW_TYPE] [int] NULL,
 CONSTRAINT [PK_CATEGORY_MASTER] PRIMARY KEY CLUSTERED 
(
	[CATEGORY_GROUP] ASC,
	[CATEGORY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_CATEGORY_MASTER', @level2type=N'COLUMN',@level2name=N'CATEGORY_GROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_CATEGORY_MASTER', @level2type=N'COLUMN',@level2name=N'CATEGORY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_CATEGORY_MASTER', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리정렬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_CATEGORY_MASTER', @level2type=N'COLUMN',@level2name=N'SORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기타입 ( 1 : 아이콘, 2 : 텍스트)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_CATEGORY_MASTER', @level2type=N'COLUMN',@level2name=N'VIEW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_CATEGORY_MASTER'
GO
