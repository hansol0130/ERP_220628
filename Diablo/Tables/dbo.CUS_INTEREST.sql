USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_INTEREST](
	[CUS_NO] [dbo].[CUS_NO] NOT NULL,
	[INT_SEQ] [int] NOT NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[PRO_TYPE] [int] NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_INTEREST] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC,
	[INT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_INTEREST', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관심상품순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_INTEREST', @level2type=N'COLUMN',@level2name=N'INT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_INTEREST', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_INTEREST', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_INTEREST', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관심상품' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_INTEREST'
GO
