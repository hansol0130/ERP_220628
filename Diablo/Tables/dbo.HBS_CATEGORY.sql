USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HBS_CATEGORY](
	[MASTER_SEQ] [int] NOT NULL,
	[CATEGORY_SEQ] [int] NOT NULL,
	[CATEGORY_NAME] [nvarchar](40) NOT NULL,
	[USE_YN] [char](1) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [dbo].[EMP_CODE] NOT NULL,
 CONSTRAINT [PK_HBS_CATEGORY] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[CATEGORY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HBS_CATEGORY] ADD  CONSTRAINT [DF_HBS_CATEGORY_USE_YN]  DEFAULT ('Y') FOR [USE_YN]
GO
ALTER TABLE [dbo].[HBS_CATEGORY] ADD  CONSTRAINT [DF_HBS_CATEGORY_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[HBS_CATEGORY]  WITH CHECK ADD  CONSTRAINT [FK_HBS_CATEGORY_HBS_MASTER] FOREIGN KEY([MASTER_SEQ])
REFERENCES [dbo].[HBS_MASTER] ([MASTER_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HBS_CATEGORY] CHECK CONSTRAINT [FK_HBS_CATEGORY_HBS_MASTER]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_CATEGORY', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_CATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_CATEGORY', @level2type=N'COLUMN',@level2name=N'CATEGORY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_CATEGORY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_CATEGORY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드카테고리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_CATEGORY'
GO
