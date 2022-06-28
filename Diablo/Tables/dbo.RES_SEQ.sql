USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_SEQ](
	[RES_TYPE] [char](1) NOT NULL,
	[SEQ_NO] [int] NULL,
 CONSTRAINT [PK_RES_SEQ] PRIMARY KEY CLUSTERED 
(
	[RES_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_SEQ] ADD  CONSTRAINT [DEF_NUM_1_1634404193]  DEFAULT ((1)) FOR [SEQ_NO]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEQ', @level2type=N'COLUMN',@level2name=N'RES_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEQ', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약번호발급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEQ'
GO
