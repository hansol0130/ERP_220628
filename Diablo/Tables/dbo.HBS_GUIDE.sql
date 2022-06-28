USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HBS_GUIDE](
	[GUI_NAME] [varchar](20) NULL,
	[REGION_CODE] [varchar](10) NULL,
	[BOARD_SEQ] [int] NOT NULL,
	[NICK_NAME] [varchar](200) NULL,
	[EMAIL] [varchar](50) NULL,
	[FILE_PATH] [varchar](200) NULL,
	[FILE_NAME] [varchar](50) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[CUS_NO] NULL,
	[NEW_CODE] [dbo].[CUS_NO] NULL,
	[PIC_COMMENT] [varchar](200) NULL,
	[DEL_YN] [char](1) NULL,
	[SHOW_COUNT] [int] NULL,
 CONSTRAINT [IDX_HBS_GUIDE] PRIMARY KEY CLUSTERED 
(
	[BOARD_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가이드명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'GUI_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'BOARD_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'닉네임' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'NICK_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'FILE_PATH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사진명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'FILE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사진설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'PIC_COMMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조회수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE', @level2type=N'COLUMN',@level2name=N'SHOW_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가이드게시판' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_GUIDE'
GO
