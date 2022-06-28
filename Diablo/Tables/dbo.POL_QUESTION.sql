USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POL_QUESTION](
	[MASTER_SEQ] [int] NOT NULL,
	[QUESTION_SEQ] [int] NOT NULL,
	[QUS_TYPE] [char](1) NOT NULL,
	[QUESTION_TITLE] [varchar](400) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
 CONSTRAINT [PK_POL_QUESTION] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[QUESTION_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[POL_QUESTION] ADD  CONSTRAINT [DF_POL_QUESTION_QUS_TYPE]  DEFAULT ('0') FOR [QUS_TYPE]
GO
ALTER TABLE [dbo].[POL_QUESTION] ADD  CONSTRAINT [DF_POL_QUESTION_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[POL_QUESTION]  WITH CHECK ADD  CONSTRAINT [FK_POL_QUESTION_POL_MASTER] FOREIGN KEY([MASTER_SEQ])
REFERENCES [dbo].[POL_MASTER] ([MASTER_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[POL_QUESTION] CHECK CONSTRAINT [FK_POL_QUESTION_POL_MASTER]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문마스터번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'질문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION', @level2type=N'COLUMN',@level2name=N'QUESTION_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 객관식, 1 : 무객관식, 2 : 주관식' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION', @level2type=N'COLUMN',@level2name=N'QUS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'질문제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION', @level2type=N'COLUMN',@level2name=N'QUESTION_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문 질문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'POL_QUESTION'
GO
