USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_BEST_TEMPLETE](
	[PART_SEQ] [int] NOT NULL,
	[TPL_SEQ] [int] NOT NULL,
	[TPL_NAME] [varchar](30) NULL,
	[TPL_REMARK] [varchar](50) NULL,
	[SHOW_YN] [char](1) NOT NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_PUB_BEST_TEMPLETE] PRIMARY KEY CLUSTERED 
(
	[PART_SEQ] ASC,
	[TPL_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'PART_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'템플릿순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'TPL_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'템플릿명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'TPL_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'템플릿비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'TPL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'활성여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트템플릿' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE'
GO
