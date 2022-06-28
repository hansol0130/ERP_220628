USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_ICON_MASTER](
	[MASTER_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[ICON_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[ICONNAME] [varchar](20) NULL,
	[FILENAME] [varchar](100) NULL,
 CONSTRAINT [PK_ICON_MASTESR] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[ICON_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BBS_ICON_MASTER]  WITH CHECK ADD  CONSTRAINT [R_27] FOREIGN KEY([MASTER_SEQ])
REFERENCES [dbo].[BBS_MASTER] ([MASTER_SEQ])
GO
ALTER TABLE [dbo].[BBS_ICON_MASTER] CHECK CONSTRAINT [R_27]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판관리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_ICON_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이콘순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_ICON_MASTER', @level2type=N'COLUMN',@level2name=N'ICON_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이콘명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_ICON_MASTER', @level2type=N'COLUMN',@level2name=N'ICONNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_ICON_MASTER', @level2type=N'COLUMN',@level2name=N'FILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이콘관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BBS_ICON_MASTER'
GO
