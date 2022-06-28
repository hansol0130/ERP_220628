USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MARKET_PRODUCT_TEMP](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[PRO_CODE] [varchar](20) NULL,
	[RES_CODE] [char](12) NULL,
	[NAME] [varchar](40) NULL,
	[TEL] [varchar](40) NULL,
	[EMAIL] [varchar](100) NULL,
	[DELIVERY_NAME] [varchar](40) NULL,
	[DELIVERY_TEL] [varchar](40) NULL,
	[ZIP_CODE] [varchar](7) NULL,
	[ADDR1] [varchar](100) NULL,
	[ADDR2] [varchar](100) NULL,
	[COUNT] [int] NULL,
	[PAY_PRICE] [money] NULL,
	[PAY_TYPE] [char](1) NULL,
	[NEW_DATE] [datetime] NOT NULL,
 CONSTRAINT [PK_MARKET_PRODUCT_TEMP] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MARKET_PRODUCT_TEMP] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'배송정보이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'DELIVERY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'배송정보전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'DELIVERY_TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'ADDR1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'ADDR2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수량' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'PAY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구매타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'PAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MARKET_PRODUCT_TEMP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
