USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_BEST_MASTER](
	[PART_SEQ] [int] NOT NULL,
	[TPL_SEQ] [int] NOT NULL,
	[MST_SEQ] [int] NOT NULL,
	[MST_NAME] [varchar](50) NULL,
	[TYPE_SEQ] [varchar](200) NULL,
	[CITY_CODE] [char](3) NULL,
	[TYPE_NAME] [varchar](30) NULL,
	[MST_REMARK] [varchar](200) NULL,
	[ORDER_NUM] [int] NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_PUB_BEST_MASTER] PRIMARY KEY CLUSTERED 
(
	[PART_SEQ] ASC,
	[TPL_SEQ] ASC,
	[MST_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_BEST_MASTER]  WITH CHECK ADD  CONSTRAINT [R_367] FOREIGN KEY([PART_SEQ], [TPL_SEQ])
REFERENCES [dbo].[PUB_BEST_TEMPLETE] ([PART_SEQ], [TPL_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_BEST_MASTER] CHECK CONSTRAINT [R_367]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'PART_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'템플릿순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'TPL_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'MST_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'MST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'TYPE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'타입명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'TYPE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'타입순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'MST_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'ORDER_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_MASTER'
GO
