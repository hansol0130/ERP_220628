USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RSH_ANSWER](
	[MASTER_SEQ] [int] NOT NULL,
	[JOIN_SEQ] [int] NOT NULL,
	[QUESTION_SEQ] [int] NOT NULL,
	[ANSWER_NO] [int] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_RSH_ANSWER] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[JOIN_SEQ] ASC,
	[QUESTION_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RSH_ANSWER]  WITH CHECK ADD  CONSTRAINT [R_363] FOREIGN KEY([MASTER_SEQ], [JOIN_SEQ])
REFERENCES [dbo].[RSH_CUSTOMER] ([MASTER_SEQ], [JOIN_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RSH_ANSWER] CHECK CONSTRAINT [R_363]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_ANSWER', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조인번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_ANSWER', @level2type=N'COLUMN',@level2name=N'JOIN_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'질문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_ANSWER', @level2type=N'COLUMN',@level2name=N'QUESTION_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택문항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_ANSWER', @level2type=N'COLUMN',@level2name=N'ANSWER_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_ANSWER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리서치 대답' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RSH_ANSWER'
GO
