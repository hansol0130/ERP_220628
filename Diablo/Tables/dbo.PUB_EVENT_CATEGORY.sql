USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_EVENT_CATEGORY](
	[EVT_SEQ] [int] NOT NULL,
	[EVT_CATE_SEQ] [int] NOT NULL,
	[EVT_CATEGORY] [int] NULL,
	[EVT_SUB_CATEGORY] [int] NULL,
	[EVT_CATEGORY_NAME] [nvarchar](100) NULL,
	[EVT_SUB_CATEGORY_NAME] [nvarchar](100) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
 CONSTRAINT [PK_PUB_EVENT_CATEGORY] PRIMARY KEY CLUSTERED 
(
	[EVT_CATE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_EVENT_CATEGORY]  WITH CHECK ADD  CONSTRAINT [FK_PUB_EVENT_CATEGORY_PUB_EVENT_CATEGORY] FOREIGN KEY([EVT_SEQ])
REFERENCES [dbo].[PUB_EVENT] ([EVT_SEQ])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_EVENT_CATEGORY] CHECK CONSTRAINT [FK_PUB_EVENT_CATEGORY_PUB_EVENT_CATEGORY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'EVT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'EVT_CATE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'EVT_CATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보조카테고리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'EVT_SUB_CATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'EVT_CATEGORY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보조카테고리명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'EVT_SUB_CATEGORY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트카테고리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_CATEGORY'
GO
