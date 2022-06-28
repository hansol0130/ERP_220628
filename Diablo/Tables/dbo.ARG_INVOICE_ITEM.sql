USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARG_INVOICE_ITEM](
	[INV_SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[TITLE] [varchar](50) NULL,
	[SHOW_YN] [char](1) NULL,
 CONSTRAINT [PK_ARG_INVOICE_ITEM] PRIMARY KEY CLUSTERED 
(
	[INV_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항목이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_ITEM', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y : 사용, N : 미사용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_ITEM', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배 인보이스 공통 항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_ITEM'
GO
