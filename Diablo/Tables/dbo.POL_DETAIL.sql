USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POL_DETAIL](
	[MASTER_SEQ] [int] NOT NULL,
	[QUESTION_SEQ] [int] NOT NULL,
	[EXAMPLE_SEQ] [int] NOT NULL,
	[EXAMPLE_DESC] [varchar](400) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
 CONSTRAINT [PK_POL_DETAIL] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[QUESTION_SEQ] ASC,
	[EXAMPLE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[POL_DETAIL] ADD  CONSTRAINT [DF_POL_DETAIL_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[POL_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK_POL_DETAIL_POL_QUESTION] FOREIGN KEY([MASTER_SEQ], [QUESTION_SEQ])
REFERENCES [dbo].[POL_QUESTION] ([MASTER_SEQ], [QUESTION_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[POL_DETAIL] CHECK CONSTRAINT [FK_POL_DETAIL_POL_QUESTION]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문마스터번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'질문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL', @level2type=N'COLUMN',@level2name=N'QUESTION_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL', @level2type=N'COLUMN',@level2name=N'EXAMPLE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL', @level2type=N'COLUMN',@level2name=N'EXAMPLE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_DETAIL'
GO
