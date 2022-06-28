USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSR_REFUND](
	[TICKET] [varchar](10) NOT NULL,
	[BSP_DAY] [varchar](10) NULL,
	[REFUND_DATE] [datetime] NULL,
	[REFUND_TYPE] [int] NULL,
	[REQUEST_DATE] [datetime] NULL,
	[FARE_USED_PRICE] [int] NULL,
	[FARE_REFUND_PRICE] [int] NULL,
	[CANCEL_CHARGE] [int] NULL,
	[TAX_REFUND1] [int] NULL,
	[TAX_REFUND2] [int] NULL,
	[TAX_REFUND3] [int] NULL,
	[COMM_REFUND] [int] NULL,
	[CASH_PRICE] [int] NULL,
	[CARD_PRICE] [int] NULL,
	[CASH_REQ_NUM] [varchar](20) NULL,
	[CARD_REQ_NUM] [varchar](20) NULL,
	[REFUND_PRICE] [int] NULL,
	[CUS_DATE] [datetime] NULL,
	[CUS_PHONE] [varchar](20) NULL,
	[REMARK] [varchar](500) NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_DSR_REFUND] PRIMARY KEY CLUSTERED 
(
	[TICKET] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSR_REFUND]  WITH CHECK ADD  CONSTRAINT [R_306] FOREIGN KEY([TICKET])
REFERENCES [dbo].[DSR_TICKET] ([TICKET])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DSR_REFUND] CHECK CONSTRAINT [R_306]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BSP 반영주기' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'BSP_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'REFUND_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 고객환불, 1 : 자체환' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'REFUND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'접수일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'REQUEST_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FARE USED' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'FARE_USED_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'REFUND PRICE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'FARE_REFUND_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CANCEL CHARGE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'CANCEL_CHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX REFUND1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'TAX_REFUND1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX_REFUND2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'TAX_REFUND2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX_REFUND3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'TAX_REFUND3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'COMM REFUND' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'COMM_REFUND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불액 현금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'CASH_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불액 카드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'CARD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현금 환불번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'CASH_REQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 환불번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'CARD_REQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 전체금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'REFUND_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객환불일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'CUS_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객연락처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'CUS_PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리자 사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_REFUND'
GO
