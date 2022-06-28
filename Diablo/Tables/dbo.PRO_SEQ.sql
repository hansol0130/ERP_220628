USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRO_SEQ](
	[PRO_TYPE] [char](1) NOT NULL,
	[SEQ_NO] [int] NULL,
 CONSTRAINT [PK_PRO_SEQ] PRIMARY KEY CLUSTERED 
(
	[PRO_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRO_SEQ] ADD  CONSTRAINT [DEF_NUM_1_1701513556]  DEFAULT ((1)) FOR [SEQ_NO]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_SEQ', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_SEQ', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사번호발급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_SEQ'
GO
