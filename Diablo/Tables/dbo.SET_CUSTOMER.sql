USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SET_CUSTOMER](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[RES_SEQ_NO] [int] NOT NULL,
	[TAX_PRICE] [int] NULL,
	[INS_PRICE] [int] NULL,
	[ETC_PRICE] [int] NULL,
	[PASS_PRICE] [int] NULL,
	[VISA_PRICE] [int] NULL,
	[REMARK] [varchar](200) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[ETC_PROFIT] [int] NULL,
	[CARD_PRICE] [int] NULL,
	[TICKET] [varchar](10) NULL,
 CONSTRAINT [PKG_SET_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[RES_CODE] ASC,
	[RES_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SET_CUSTOMER]  WITH CHECK ADD  CONSTRAINT [R_315] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[SET_MASTER] ([PRO_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SET_CUSTOMER] CHECK CONSTRAINT [R_315]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'RES_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'INS_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'ETC_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PASS_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비자금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'VISA_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타수익' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'ETC_PROFIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드수수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER', @level2type=N'COLUMN',@level2name=N'CARD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'개인경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_CUSTOMER'
GO
