USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAX_CATEGORY](
	[FAX_CAT_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[SUBJECT] [varchar](50) NULL,
	[DEL_YN] [char](1) NULL,
	[FAX_GROUP] [int] NOT NULL,
 CONSTRAINT [PK_FAX_CATEGORY] PRIMARY KEY CLUSTERED 
(
	[FAX_GROUP] ASC,
	[FAX_CAT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스카테고리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_CATEGORY', @level2type=N'COLUMN',@level2name=N'FAX_CAT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_CATEGORY', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_CATEGORY', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_CATEGORY', @level2type=N'COLUMN',@level2name=N'FAX_GROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스카테고리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_CATEGORY'
GO
