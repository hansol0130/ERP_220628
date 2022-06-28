USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_JOINT_MASTER](
	[JOINT_SEQ] [int] NOT NULL,
	[TYPE] [int] NULL,
	[SUBJECT] [varchar](50) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[VIEW_YN] [char](1) NULL,
	[TOP_URL] [varchar](100) NULL,
	[MENU_VIEW_YN] [char](1) NULL,
	[MENU_STYLE] [int] NULL,
	[MENU_COMMON_CSS] [varchar](500) NULL,
	[LIST_VIEW_YN] [char](1) NULL,
	[LIST_COUNT] [int] NULL,
	[READ_COUNT] [int] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_PUB_JOINT_MASTER] PRIMARY KEY CLUSTERED 
(
	[JOINT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_JOINT_MASTER] ADD  DEFAULT ('N') FOR [VIEW_YN]
GO
ALTER TABLE [dbo].[PUB_JOINT_MASTER] ADD  DEFAULT ('N') FOR [MENU_VIEW_YN]
GO
ALTER TABLE [dbo].[PUB_JOINT_MASTER] ADD  DEFAULT ((1)) FOR [MENU_STYLE]
GO
ALTER TABLE [dbo].[PUB_JOINT_MASTER] ADD  DEFAULT ('N') FOR [LIST_VIEW_YN]
GO
ALTER TABLE [dbo].[PUB_JOINT_MASTER] ADD  DEFAULT ((2)) FOR [LIST_COUNT]
GO
ALTER TABLE [dbo].[PUB_JOINT_MASTER] ADD  DEFAULT ((0)) FOR [READ_COUNT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기획전번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'JOINT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화면표시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'VIEW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상단URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'TOP_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴표시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'MENU_VIEW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴스타일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'MENU_STYLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴기본클래스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'MENU_COMMON_CSS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품표시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'LIST_VIEW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품리스트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'LIST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조회수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'READ_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공동기획전 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_JOINT_MASTER'
GO
