USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_MASTER](
	[MASTER_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[MASTER_TYPE] [char](1) NULL,
	[MASTER_ATTR] [char](2) NULL,
	[MASTER_SUBJECT] [nvarchar](50) NULL,
	[FILE_COUNT] [int] NULL,
	[FILE_MAXSIZE] [int] NULL,
	[NOTICE_YN] [char](1) NULL,
	[SHOW_COUNT] [int] NULL,
	[HISTORY_YN] [char](1) NULL,
	[COMMENT_YN] [char](1) NULL,
	[USE_YN] [char](1) NULL,
	[REALNAME_YN] [char](1) NULL,
	[CATEGORY_GROUP] [varchar](20) NULL,
	[LIST_SHOW_TYPE] [char](1) NULL,
	[ICON_YN] [char](1) NULL,
	[TEAM_CODE] [dbo].[TEAM_CODE] NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[SCOPE_YN] [char](1) NULL,
	[MANAGER_YN] [char](1) NULL,
 CONSTRAINT [PK_BBS_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BBS_MASTER] ADD  CONSTRAINT [DF_BBS_MASTER_SCOPE_YN]  DEFAULT ('N') FOR [SCOPE_YN]
GO
ALTER TABLE [dbo].[BBS_MASTER] ADD  CONSTRAINT [DF_BBS_MASTER_MANAGER_YN]  DEFAULT ('N') FOR [MANAGER_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판관리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 일반게시판, 2 : 상태게시판, 3 : 히스토리게시판' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'10 : 일반, 20 : 포토, 30 : 미디어, 40 : 질문답변 일체형' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_ATTR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첨부파일갯수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일사이즈제한' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_MAXSIZE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공지사항유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'NOTICE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화면표시갯수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'히스토리유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'HISTORY_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'댓글유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'COMMENT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'N : 실명, Y: 익명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'REALNAME_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'CATEGORY_GROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리스트시 보여지는 타입 (1 : 일반 리스트, 2 : 이미지 리스트)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'LIST_SHOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이콘사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'ICON_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'접근여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'SCOPE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경영정보여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER', @level2type=N'COLUMN',@level2name=N'MANAGER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_MASTER'
GO
