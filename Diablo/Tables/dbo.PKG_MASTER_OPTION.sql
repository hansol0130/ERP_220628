USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_OPTION](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[OPT_SEQ] [int] NOT NULL,
	[OPT_NAME] [nvarchar](200) NULL,
	[OPT_CONTENT] [nvarchar](400) NULL,
	[OPT_PRICE] [nvarchar](60) NULL,
	[OPT_USETIME] [nvarchar](60) NULL,
	[OPT_REPLACE] [nvarchar](400) NULL,
	[OPT_PLACE] [nvarchar](200) NULL,
	[OPT_COMPANION] [nvarchar](60) NULL,
 CONSTRAINT [PK_PKG_MASTER_OPTION] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[OPT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_OPTION]  WITH CHECK ADD  CONSTRAINT [R_426] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_MASTER_OPTION] CHECK CONSTRAINT [R_426]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소요시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_USETIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대체일정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_REPLACE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대기장소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_PLACE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동행여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION', @level2type=N'COLUMN',@level2name=N'OPT_COMPANION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터옵션정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_OPTION'
GO
