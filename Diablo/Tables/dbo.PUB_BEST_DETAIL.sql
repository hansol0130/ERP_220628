USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_BEST_DETAIL](
	[PART_SEQ] [int] NOT NULL,
	[TPL_SEQ] [int] NOT NULL,
	[MST_SEQ] [int] NOT NULL,
	[DTI_SEQ] [int] NOT NULL,
	[DTI_ITEM1] [varchar](50) NULL,
	[DTI_ITEM2] [varchar](50) NULL,
	[DTI_ITEM3] [varchar](50) NULL,
	[DTI_ITEM4] [varchar](50) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_PUB_BEST_DETAIL] PRIMARY KEY CLUSTERED 
(
	[PART_SEQ] ASC,
	[TPL_SEQ] ASC,
	[MST_SEQ] ASC,
	[DTI_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_BEST_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_368] FOREIGN KEY([PART_SEQ], [TPL_SEQ], [MST_SEQ])
REFERENCES [dbo].[PUB_BEST_MASTER] ([PART_SEQ], [TPL_SEQ], [MST_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_BEST_DETAIL] CHECK CONSTRAINT [R_368]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'PART_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'템플릿순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'TPL_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'MST_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'디테일순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'DTI_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항목1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'DTI_ITEM1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항목2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'DTI_ITEM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항목3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'DTI_ITEM3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항목4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'DTI_ITEM4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트디테일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_DETAIL'
GO
