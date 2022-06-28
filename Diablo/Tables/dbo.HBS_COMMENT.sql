USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HBS_COMMENT](
	[MASTER_SEQ] [int] NOT NULL,
	[BOARD_SEQ] [int] NOT NULL,
	[COMMENT_SEQ] [int] NOT NULL,
	[CONTENTS] [nvarchar](1000) NULL,
	[DEL_YN] [char](1) NOT NULL,
	[NICKNAME] [varchar](20) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [int] NULL,
	[DEL_DATE] [datetime] NULL,
	[DEL_CODE] [int] NULL,
	[PARENT] [int] NULL,
	[DEPTH] [int] NOT NULL,
 CONSTRAINT [PK_HBS_COMMENT] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BOARD_SEQ] ASC,
	[COMMENT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HBS_COMMENT] ADD  CONSTRAINT [DF_HBS_COMMENT_DEL_YN]  DEFAULT ('N') FOR [DEL_YN]
GO
ALTER TABLE [dbo].[HBS_COMMENT] ADD  CONSTRAINT [DF_HBS_COMMENT_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[HBS_COMMENT] ADD  DEFAULT ((1)) FOR [DEPTH]
GO
ALTER TABLE [dbo].[HBS_COMMENT]  WITH CHECK ADD  CONSTRAINT [FK_HBS_COMMENT_HBS_DETAIL] FOREIGN KEY([MASTER_SEQ], [BOARD_SEQ])
REFERENCES [dbo].[HBS_DETAIL] ([MASTER_SEQ], [BOARD_SEQ])
GO
ALTER TABLE [dbo].[HBS_COMMENT] CHECK CONSTRAINT [FK_HBS_COMMENT_HBS_DETAIL]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'BOARD_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'커멘트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'COMMENT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'커멘트내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'닉네임' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'NICKNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'DEL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'DEL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부모게시글' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'PARENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'레벨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT', @level2type=N'COLUMN',@level2name=N'DEPTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드커멘트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_COMMENT'
GO
