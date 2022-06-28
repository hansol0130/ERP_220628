USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HBS_FILE](
	[MASTER_SEQ] [int] NOT NULL,
	[BOARD_SEQ] [int] NOT NULL,
	[FILE_SEQ] [int] NOT NULL,
	[FILE_NAME] [nvarchar](255) NULL,
	[FILE_SIZE] [int] NULL,
 CONSTRAINT [PK_HBS_FILE] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BOARD_SEQ] ASC,
	[FILE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HBS_FILE]  WITH CHECK ADD  CONSTRAINT [FK_HBS_FILE_HBS_DETAIL] FOREIGN KEY([MASTER_SEQ], [BOARD_SEQ])
REFERENCES [dbo].[HBS_DETAIL] ([MASTER_SEQ], [BOARD_SEQ])
GO
ALTER TABLE [dbo].[HBS_FILE] CHECK CONSTRAINT [FK_HBS_FILE_HBS_DETAIL]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_FILE', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_FILE', @level2type=N'COLUMN',@level2name=N'BOARD_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_FILE', @level2type=N'COLUMN',@level2name=N'FILE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_FILE', @level2type=N'COLUMN',@level2name=N'FILE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일사이즈' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_FILE', @level2type=N'COLUMN',@level2name=N'FILE_SIZE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_FILE'
GO
