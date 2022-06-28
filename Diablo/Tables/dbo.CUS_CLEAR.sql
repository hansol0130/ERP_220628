USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_CLEAR](
	[CUS_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NULL,
	[CUS_NO_LIST] [varchar](1000) NULL,
	[EMP_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_CLEAR] PRIMARY KEY CLUSTERED 
(
	[CUS_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_CLEAR] ADD  CONSTRAINT [DEF_CUS_CLEAR_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기준 CUS_NO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CLEAR', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'병합대상 CUS_NO List' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CLEAR', @level2type=N'COLUMN',@level2name=N'CUS_NO_LIST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'병합기록' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CLEAR'
GO
