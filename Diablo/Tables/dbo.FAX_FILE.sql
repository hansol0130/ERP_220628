USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAX_FILE](
	[FILE_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[FILENAME] [varchar](100) NULL,
	[FILEURL] [varchar](200) NULL,
	[FAX_SEQ] [char](17) NOT NULL,
 CONSTRAINT [PK_FAX_FILE] PRIMARY KEY CLUSTERED 
(
	[FAX_SEQ] ASC,
	[FILE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FAX_FILE]  WITH CHECK ADD  CONSTRAINT [R_49] FOREIGN KEY([FAX_SEQ])
REFERENCES [dbo].[FAX_MASTER] ([FAX_SEQ])
GO
ALTER TABLE [dbo].[FAX_FILE] CHECK CONSTRAINT [R_49]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_FILE', @level2type=N'COLUMN',@level2name=N'FILE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_FILE', @level2type=N'COLUMN',@level2name=N'FILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_FILE', @level2type=N'COLUMN',@level2name=N'FILEURL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_FILE', @level2type=N'COLUMN',@level2name=N'FAX_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_FILE'
GO
