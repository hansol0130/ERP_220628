USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_HISTORY_FILE](
	[MASTER_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[BBS_SEQ] [int] NOT NULL,
	[HISTORY_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[FILE_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[FILENAME] [varchar](100) NULL,
	[FILEURL] [varchar](200) NULL,
 CONSTRAINT [PK_BBS_HISTORY_FILE] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BBS_SEQ] ASC,
	[HISTORY_SEQ] ASC,
	[FILE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BBS_HISTORY_FILE]  WITH CHECK ADD  CONSTRAINT [R_43] FOREIGN KEY([MASTER_SEQ], [BBS_SEQ], [HISTORY_SEQ])
REFERENCES [dbo].[BBS_DETAIL_HISTORY] ([MASTER_SEQ], [BBS_SEQ], [HISTORY_SEQ])
GO
ALTER TABLE [dbo].[BBS_HISTORY_FILE] CHECK CONSTRAINT [R_43]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판관리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_HISTORY_FILE', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시물순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_HISTORY_FILE', @level2type=N'COLUMN',@level2name=N'BBS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'히스토리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_HISTORY_FILE', @level2type=N'COLUMN',@level2name=N'HISTORY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_HISTORY_FILE', @level2type=N'COLUMN',@level2name=N'FILE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_HISTORY_FILE', @level2type=N'COLUMN',@level2name=N'FILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_HISTORY_FILE', @level2type=N'COLUMN',@level2name=N'FILEURL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'히스토리파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_HISTORY_FILE'
GO
