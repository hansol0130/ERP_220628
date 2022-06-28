USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSR_TICKET](
	[TICKET] [varchar](10) NOT NULL,
	[TICKET_STATUS] [int] NULL,
	[FARE_TYPE] [int] NULL,
	[START_DATE] [datetime] NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[AIRLINE_NUM] [varchar](3) NULL,
	[AIRLINE_CODE] [varchar](2) NULL,
	[CONJ_YN] [varchar](1) NULL,
	[ROUTING] [varchar](30) NULL,
	[FARE] [float] NULL,
	[DISCOUNT] [float] NULL,
	[COMM_RATE] [varchar](5) NULL,
	[COMM_PRICE] [float] NULL,
	[NET_PRICE] [float] NULL,
	[TAX_PRICE] [float] NULL,
	[FOP] [int] NULL,
	[CASH_PRICE] [float] NULL,
	[CARD_PRICE] [float] NULL,
	[CARD_TYPE] [varchar](2) NULL,
	[CARD_NUM] [varchar](20) NULL,
	[EXPIRE_DATE] [varchar](4) NULL,
	[CARD_AUTH] [varchar](8) NULL,
	[INSTALLMENT] [varchar](3) NULL,
	[PKG_PCC] [varchar](9) NULL,
	[TKT_PCC] [varchar](4) NULL,
	[ITEM_NO] [varchar](6) NULL,
	[PNR] [varchar](9) NULL,
	[PAX_NAME] [varchar](50) NULL,
	[ISSUE_DATE] [datetime] NULL,
	[PRINTER] [varchar](4) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[ISSUE_CODE] [dbo].[EMP_CODE] NULL,
	[SALE_CODE] [dbo].[EMP_CODE] NULL,
	[REGION_CODE] [dbo].[REGION_CODE] NULL,
	[TICKET_COUNT] [int] NULL,
	[DSR_SEQ] [int] NULL,
	[TICKET_TYPE] [int] NULL,
	[PRO_TYPE] [int] NULL,
	[REQUEST_CODE] [varchar](20) NULL,
	[RES_SEQ_NO] [int] NULL,
	[COMPANY] [int] NULL,
	[GDS] [int] NULL,
	[PARENT_TICKET] [varchar](10) NULL,
	[EV_YM] [char](8) NULL,
	[EV_SEQ] [int] NULL,
	[CLOSE_YN] [char](1) NULL,
	[CITY_CODE] [char](3) NULL,
	[END_DATE] [datetime] NULL,
	[QUE_PRICE] [float] NULL,
	[AIR_CLASS] [varchar](1) NULL,
 CONSTRAINT [PK_DSR_TICKET] PRIMARY KEY CLUSTERED 
(
	[TICKET] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSR_TICKET] ADD  CONSTRAINT [DF_DSR_TICKET_COMM_RATE]  DEFAULT ('0') FOR [COMM_RATE]
GO
ALTER TABLE [dbo].[DSR_TICKET] ADD  CONSTRAINT [DF_DSR_TICKET_CLOSE_YN]  DEFAULT ('N') FOR [CLOSE_YN]
GO
ALTER TABLE [dbo].[DSR_TICKET] ADD  DEFAULT ((0)) FOR [QUE_PRICE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓상태 (0 : 전체, 1 : Normal, 2 : Void, 3 : Refund)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'TICKET_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 없음, 1 : Normal , 2 : Child, 3 : Infant, 4 : FOC, 5 : AD, 6 : 예외, 7 : REFUND, 8 : REFUND_CHILD, 9 : REFUND_INFANT, 10 : TC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'FARE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'AIRLINE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CONJUNCTION여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'CONJ_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ROUTING' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'ROUTING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FARE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'FARE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DISCOUNT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'DISCOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'COMMISION CODE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'COMM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'COMMISION AMOUNT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'COMM_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NET' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'NET_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 없음, 1 : 카드, 2 : 현금, 3 : 복합' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'FOP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CASH AMOUNT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'CASH_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CARD AMOUNT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'CARD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'CARD_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CARD NUMBER' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'CARD_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유효기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'EXPIRE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드승인번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'CARD_AUTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할부개월수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'INSTALLMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부킹PCC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'PKG_PCC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권PCC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'TKT_PCC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ITEM 번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'ITEM_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'PNR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PAX NAME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'PAX_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권기' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'PRINTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권자사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'ISSUE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매자사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'SALE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'TICKET_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DSR_SEQ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'DSR_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 전체, 1 : BSP, 2 : ATR, 3 : 기타' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'TICKET_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권의뢰번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'REQUEST_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'RES_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 전체, 1 : 본사, 2 : 부산, 3 : 대전' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'COMPANY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GDS ( 0 : 전체, 1 : TOPAS, 2 : ABACUS, 3 : GALILEO, 4 : WORLDSPAN, 5 : AMADEUS, 10 : JINAIR, 11 : CebuPacific, 100 : AIRBUSAN, 101 : AMADEUS, (102 : 국내, ABACUS국내), 103 : 진에어, 104 : 티웨이, 105 : AIRBUSAN국내)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'GDS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부모티켓' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'PARENT_TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EV_YM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'EV_YM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EV_SEQ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'EV_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마감여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'CLOSE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'큐차지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'QUE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공클래스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET', @level2type=N'COLUMN',@level2name=N'AIR_CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DSR티켓정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TICKET'
GO
