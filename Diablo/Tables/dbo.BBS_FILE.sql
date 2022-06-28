USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_FILE](
	[MASTER_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[BBS_SEQ] [int] NOT NULL,
	[FILE_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[FILENAME] [varchar](100) NULL,
	[FILEURL] [varchar](200) NULL,
 CONSTRAINT [PK_BBS_FILE] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BBS_SEQ] ASC,
	[FILE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BBS_FILE]  WITH CHECK ADD  CONSTRAINT [R_24] FOREIGN KEY([MASTER_SEQ], [BBS_SEQ])
REFERENCES [dbo].[BBS_DETAIL] ([MASTER_SEQ], [BBS_SEQ])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BBS_FILE] CHECK CONSTRAINT [R_24]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판관리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_FILE', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시물순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_FILE', @level2type=N'COLUMN',@level2name=N'BBS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_FILE', @level2type=N'COLUMN',@level2name=N'FILE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_FILE', @level2type=N'COLUMN',@level2name=N'FILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_FILE', @level2type=N'COLUMN',@level2name=N'FILEURL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_FILE'
GO
