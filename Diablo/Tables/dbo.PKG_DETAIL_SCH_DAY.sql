USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL_SCH_DAY](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[SCH_SEQ] [int] NOT NULL,
	[DAY_SEQ] [int] NOT NULL,
	[DAY_NUMBER] [int] NULL,
	[FREE_SCH_YN] [char](1) NULL,
 CONSTRAINT [PK_PKG_DETAIL_SCH_DAY] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[SCH_SEQ] ASC,
	[DAY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_DETAIL_SCH_DAY]  WITH CHECK ADD  CONSTRAINT [R_147] FOREIGN KEY([PRO_CODE], [SCH_SEQ])
REFERENCES [dbo].[PKG_DETAIL_SCH_MASTER] ([PRO_CODE], [SCH_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_DETAIL_SCH_DAY] CHECK CONSTRAINT [R_147]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_DAY', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_DAY', @level2type=N'COLUMN',@level2name=N'SCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_DAY', @level2type=N'COLUMN',@level2name=N'DAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_DAY', @level2type=N'COLUMN',@level2name=N'DAY_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자유일정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_DAY', @level2type=N'COLUMN',@level2name=N'FREE_SCH_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사일정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_DAY'
GO
