USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RSH_DETAIL](
	[MASTER_SEQ] [int] NOT NULL,
	[QUESTION_SEQ] [int] NOT NULL,
	[EXAMPLE_SEQ] [int] NOT NULL,
	[EXAMPLE_DESC] [varchar](200) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_RSH_DETAIL] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[QUESTION_SEQ] ASC,
	[EXAMPLE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RSH_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_362] FOREIGN KEY([MASTER_SEQ], [QUESTION_SEQ])
REFERENCES [dbo].[RSH_QUESTION] ([MASTER_SEQ], [QUESTION_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RSH_DETAIL] CHECK CONSTRAINT [R_362]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'질문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL', @level2type=N'COLUMN',@level2name=N'QUESTION_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL', @level2type=N'COLUMN',@level2name=N'EXAMPLE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL', @level2type=N'COLUMN',@level2name=N'EXAMPLE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리서치 예문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_DETAIL'
GO
