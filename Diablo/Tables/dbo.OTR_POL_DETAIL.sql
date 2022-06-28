USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OTR_POL_DETAIL](
	[OTR_POL_MASTER_SEQ] [int] NOT NULL,
	[OTR_POL_QUESTION_SEQ] [int] NOT NULL,
	[OTR_POL_EXAMPLE_SEQ] [int] NOT NULL,
	[EXAMPLE_DESC] [varchar](2000) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NOT NULL,
 CONSTRAINT [PK_OTR_POL_DETAIL] PRIMARY KEY CLUSTERED 
(
	[OTR_POL_MASTER_SEQ] ASC,
	[OTR_POL_QUESTION_SEQ] ASC,
	[OTR_POL_EXAMPLE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OTR_POL_DETAIL]  WITH CHECK ADD FOREIGN KEY([OTR_POL_MASTER_SEQ], [OTR_POL_QUESTION_SEQ])
REFERENCES [dbo].[OTR_POL_QUESTION] ([OTR_POL_MASTER_SEQ], [OTR_POL_QUESTION_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서설문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL', @level2type=N'COLUMN',@level2name=N'OTR_POL_MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서설문질문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL', @level2type=N'COLUMN',@level2name=N'OTR_POL_QUESTION_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서설문상세번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL', @level2type=N'COLUMN',@level2name=N'OTR_POL_EXAMPLE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL', @level2type=N'COLUMN',@level2name=N'EXAMPLE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서 설문상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_DETAIL'
GO
