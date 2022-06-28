USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_HTL_PAY_LOG](
	[RESV_NO] [int] NOT NULL,
	[PAY_NO] [int] NOT NULL,
	[PAY_DATE] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RESV_NO] ASC,
	[PAY_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_HTL_PAY_LOG] ADD  CONSTRAINT [DF_RES_HTL_PAY_LOG_PAY_DATE]  DEFAULT (getdate()) FOR [PAY_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SUP 예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_PAY_LOG', @level2type=N'COLUMN',@level2name=N'RESV_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SUP PAY번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_PAY_LOG', @level2type=N'COLUMN',@level2name=N'PAY_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_PAY_LOG', @level2type=N'COLUMN',@level2name=N'PAY_DATE'
GO
