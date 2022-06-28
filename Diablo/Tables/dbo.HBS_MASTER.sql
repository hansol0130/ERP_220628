USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HBS_MASTER](
	[MASTER_SEQ] [int] NOT NULL,
	[SUBJECT] [nvarchar](200) NOT NULL,
	[DESC] [nvarchar](255) NULL,
	[BOARD_TYPE] [int] NULL,
	[NOTICE_YN] [char](1) NOT NULL,
	[COMMENT_YN] [char](1) NOT NULL,
	[REPLY_YN] [char](1) NOT NULL,
	[REGION_YN] [char](1) NOT NULL,
	[SECRET_YN] [char](1) NULL,
	[FILE_MAXSIZE] [int] NULL,
	[FILE_COUNT] [int] NULL,
	[LIST_COUNT] [int] NULL,
	[USE_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [dbo].[EMP_CODE] NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [dbo].[EMP_CODE] NULL,
	[GROUP_CODE] [varchar](1) NULL,
	[ADMIN_YN] [char](1) NULL,
	[LIST_TOP] [varchar](10) NULL,
	[LIST_BODY] [varchar](10) NULL,
	[VIEW_TOP] [varchar](10) NULL,
 CONSTRAINT [PK_HBS_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HBS_MASTER] ADD  CONSTRAINT [DF_HBS_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[HBS_MASTER] ADD  CONSTRAINT [DEF_HBS_MASTER_ADMIN_YN]  DEFAULT ('Y') FOR [ADMIN_YN]
GO
ALTER TABLE [dbo].[HBS_MASTER] ADD  CONSTRAINT [DEF_HBS_MASTER_LIST_TOP]  DEFAULT ('111') FOR [LIST_TOP]
GO
ALTER TABLE [dbo].[HBS_MASTER] ADD  CONSTRAINT [DEF_HBS_MASTER_LIST_BODY]  DEFAULT ('11111') FOR [LIST_BODY]
GO
ALTER TABLE [dbo].[HBS_MASTER] ADD  CONSTRAINT [DEF_HBS_MASTER_VIEW_TOP]  DEFAULT ('11111') FOR [VIEW_TOP]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 일반, 1 : 답변' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'BOARD_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공지유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'NOTICE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'댓글유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'COMMENT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'답글유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'REPLY_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역구분유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'REGION_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비밀유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'SECRET_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일사이즈' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_MAXSIZE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업로드파일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출력글수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'LIST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LIST_TOP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'LIST_TOP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LIST_BODY' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'LIST_BODY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VIEW_TOP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER', @level2type=N'COLUMN',@level2name=N'VIEW_TOP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_MASTER'
GO
