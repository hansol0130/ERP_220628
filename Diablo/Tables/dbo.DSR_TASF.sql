USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSR_TASF](
	[AIRLINE_NUM] [varchar](3) NOT NULL,
	[AIRLINE_CODE] [varchar](2) NOT NULL,
	[FOP] [int] NOT NULL,
	[TOTAL_PRICE] [money] NULL,
	[CARD_PRICE] [money] NULL,
	[CASH_PRICE] [money] NULL,
	[CARD_NUM] [varchar](16) NULL,
	[EXPIRE_DATE] [varchar](4) NULL,
	[CARD_AUTH] [varchar](8) NULL,
	[TICKET_STATUS] [int] NOT NULL,
	[GDS] [int] NOT NULL,
	[COMPANY] [int] NOT NULL,
	[CARD_RATE] [numeric](5, 2) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[ISSUE_DATE] [datetime] NULL,
	[PNR] [varchar](9) NULL,
	[IATA_FEE] [money] NULL,
	[CARD_COMM] [money] NULL,
	[PARENT_TICKET] [varchar](10) NULL,
	[TICKET] [varchar](10) NOT NULL,
 CONSTRAINT [PK_DSR_TASF] PRIMARY KEY CLUSTERED 
(
	[TICKET] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSR_TASF]  WITH CHECK ADD  CONSTRAINT [R_346] FOREIGN KEY([PARENT_TICKET])
REFERENCES [dbo].[DSR_TICKET] ([TICKET])
GO
ALTER TABLE [dbo].[DSR_TASF] CHECK CONSTRAINT [R_346]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'AIRLINE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'없음 카드 현금 복합' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'FOP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전체금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'TOTAL_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'CARD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현금금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'CASH_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CARD NUMBER' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'CARD_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유효기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'EXPIRE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드승인번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'CARD_AUTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 정상, 1 :VOID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'TICKET_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : Topas, 2 : Abacus, 3 : Galileo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'GDS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 본사, 1 : 부산' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'COMPANY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'CARD_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'PNR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IATA 트랙잭션피' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'IATA_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드수수료금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'CARD_COMM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부모티켓번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'PARENT_TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF', @level2type=N'COLUMN',@level2name=N'TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DSR_TASF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_TASF'
GO
