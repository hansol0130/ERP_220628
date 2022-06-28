USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_COMMENT](
	[MASTER_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[BBS_SEQ] [int] NOT NULL,
	[COMMENT_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[CONTENTS] [varchar](3000) NULL,
	[PASSWORD] [varchar](20) NULL,
	[STATUS] [char](1) NULL,
	[FINISH_DATE] [datetime] NULL,
	[DEL_YN] [char](1) NULL,
	[TEAM_CODE] [dbo].[TEAM_CODE] NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_BBS_COMMENT] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BBS_SEQ] ASC,
	[COMMENT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BBS_COMMENT]  WITH CHECK ADD  CONSTRAINT [R_23] FOREIGN KEY([MASTER_SEQ], [BBS_SEQ])
REFERENCES [dbo].[BBS_DETAIL] ([MASTER_SEQ], [BBS_SEQ])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BBS_COMMENT] CHECK CONSTRAINT [R_23]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판관리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시물순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'BBS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'댓글순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'COMMENT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'댓글내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비밀번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'PASSWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 진행, 2 : 보류, 3 : 완료, 4 : 내부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'완료예상일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'FINISH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'NEW_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'EDT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판댓글' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_COMMENT'
GO
