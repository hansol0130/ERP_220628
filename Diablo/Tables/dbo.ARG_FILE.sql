USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARG_FILE](
	[ARG_CODE] [varchar](12) NOT NULL,
	[GRP_SEQ_NO] [int] NOT NULL,
	[FILE_NO] [int] NOT NULL,
	[FILE_PATH] [nvarchar](200) NULL,
 CONSTRAINT [PK_ARG_FILE] PRIMARY KEY CLUSTERED 
(
	[ARG_CODE] ASC,
	[GRP_SEQ_NO] ASC,
	[FILE_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARG_FILE]  WITH CHECK ADD  CONSTRAINT [R_410] FOREIGN KEY([ARG_CODE], [GRP_SEQ_NO])
REFERENCES [dbo].[ARG_DETAIL] ([ARG_CODE], [GRP_SEQ_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ARG_FILE] CHECK CONSTRAINT [R_410]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_FILE', @level2type=N'COLUMN',@level2name=N'ARG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_FILE', @level2type=N'COLUMN',@level2name=N'GRP_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_FILE', @level2type=N'COLUMN',@level2name=N'FILE_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_FILE', @level2type=N'COLUMN',@level2name=N'FILE_PATH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배 세부 파일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_FILE'
GO
