USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_DETAIL](
	[MASTER_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[BBS_SEQ] [int] NOT NULL,
	[CATEGORY_GROUP] [char](3) NULL,
	[CATEGORY_SEQ] [dbo].[SEQ_NO] NULL,
	[PASSWORD] [varchar](20) NULL,
	[SUBJECT] [nvarchar](200) NULL,
	[NOTICE_YN] [char](1) NULL,
	[ICON_SEQ] [dbo].[SEQ_NO] NULL,
	[STATUS] [char](1) NULL,
	[STATUS_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[FINISH_DATE] [datetime] NULL,
	[FINISH_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[COMMENT_COUNT] [int] NULL,
	[FILE_COUNT] [int] NULL,
	[FILE_PATH] [varchar](200) NULL,
	[CONTENTS] [nvarchar](max) NULL,
	[LEVEL] [int] NULL,
	[PARENT_SEQ] [int] NULL,
	[READ_NUM] [int] NULL,
	[IPADDRESS] [varchar](15) NULL,
	[TEAM_CODE] [dbo].[TEAM_CODE] NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[DEL_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[SCOPE_TYPE] [char](1) NULL,
 CONSTRAINT [PK_BBS_DETAIL] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BBS_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[BBS_DETAIL] ADD  CONSTRAINT [DF_BBS_DETAIL_SCOPE_TYPE]  DEFAULT ('1') FOR [SCOPE_TYPE]
GO
ALTER TABLE [dbo].[BBS_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_22] FOREIGN KEY([MASTER_SEQ])
REFERENCES [dbo].[BBS_MASTER] ([MASTER_SEQ])
GO
ALTER TABLE [dbo].[BBS_DETAIL] CHECK CONSTRAINT [R_22]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판관리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시물순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'BBS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'CATEGORY_GROUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'CATEGORY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비밀번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'PASSWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공지사항유무 ( 0 : None, 1 : True, 2 : False )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'NOTICE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이콘순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'ICON_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 접수, 2 : 진행, 3 : 완료, 4 : 보류, 5 : 반송, 6 : 내부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'진행상태수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'STATUS_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'완료예상일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'FINISH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'완료예상일수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'FINISH_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코멘트갯수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'COMMENT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일갯수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'FILE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일위치' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'FILE_PATH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'레벨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'LEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상위게시물코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'PARENT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조회수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'READ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이피' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'IPADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 전체, 2 : 팀내부만, 3 : 작성자만 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL', @level2type=N'COLUMN',@level2name=N'SCOPE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시물' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_DETAIL'
GO
