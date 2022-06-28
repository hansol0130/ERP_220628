USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_SCH_MASTER](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[SCH_SEQ] [int] NOT NULL,
	[SCH_NAME] [nvarchar](50) NULL,
 CONSTRAINT [PK_PKG_MASTER_SCH_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[SCH_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_SCH_MASTER]  WITH CHECK ADD  CONSTRAINT [R_336] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_MASTER_SCH_MASTER] CHECK CONSTRAINT [R_336]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MASTER', @level2type=N'COLUMN',@level2name=N'SCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MASTER', @level2type=N'COLUMN',@level2name=N'SCH_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터일정마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MASTER'
GO
