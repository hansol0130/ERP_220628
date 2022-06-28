USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SET_AIR_CUSTOMER](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[AIR_SEQ_NO] [int] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[RES_SEQ_NO] [int] NOT NULL,
	[FARE_TYPE] [dbo].[FARE_TYPE] NULL,
	[FARE_PRICE] [int] NULL,
	[DC_PRICE] [int] NULL,
	[NET_PRICE] [int] NULL,
	[COM_RATE] [varchar](5) NULL,
	[VAT_PRICE] [int] NULL,
	[PAY_PRICE] [int] NULL,
	[TAX_PRICE] [int] NULL,
	[PROFIT] [int] NULL,
	[COMM_PRICE] [int] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[DSR_YN] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[AIR_SEQ_NO] ASC,
	[RES_SEQ_NO] ASC,
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SET_AIR_CUSTOMER] ADD  CONSTRAINT [DF_SET_AIR_CUSTOMER_FARE_TYPE]  DEFAULT ((1)) FOR [FARE_TYPE]
GO
ALTER TABLE [dbo].[SET_AIR_CUSTOMER]  WITH CHECK ADD  CONSTRAINT [R_311] FOREIGN KEY([PRO_CODE], [AIR_SEQ_NO])
REFERENCES [dbo].[SET_AIR_AGENT] ([PRO_CODE], [AIR_SEQ_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SET_AIR_CUSTOMER] CHECK CONSTRAINT [R_311]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'AIR_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'RES_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요금구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'FARE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FARE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'FARE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'DC_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NET' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NET_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'COM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VAT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'VAT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PAY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수익' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PROFIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DSR 확인 유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER', @level2type=N'COLUMN',@level2name=N'DSR_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공비 거래처별 고객' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_CUSTOMER'
GO
