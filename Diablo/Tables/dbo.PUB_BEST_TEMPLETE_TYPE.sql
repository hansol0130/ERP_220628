USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_BEST_TEMPLETE_TYPE](
	[PART_SEQ] [int] NOT NULL,
	[TPL_SEQ] [int] NOT NULL,
	[TYPE_SEQ] [int] NOT NULL,
	[TYPE_NAME] [varchar](30) NULL,
	[TYPE_REMARK] [varchar](100) NULL,
	[NEW_CODE] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [varchar](20) NULL,
	[EDT_DATE] [datetime] NULL,
 CONSTRAINT [PK_PUB_BEST_TEMPLETE_TYPE] PRIMARY KEY CLUSTERED 
(
	[PART_SEQ] ASC,
	[TPL_SEQ] ASC,
	[TYPE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_BEST_TEMPLETE_TYPE]  WITH CHECK ADD  CONSTRAINT [R_369] FOREIGN KEY([PART_SEQ], [TPL_SEQ])
REFERENCES [dbo].[PUB_BEST_TEMPLETE] ([PART_SEQ], [TPL_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_BEST_TEMPLETE_TYPE] CHECK CONSTRAINT [R_369]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'PART_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'템플릿순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'TPL_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'타입순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'TYPE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'타입명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'TYPE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'타입비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'TYPE_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트템플릿타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_BEST_TEMPLETE_TYPE'
GO
