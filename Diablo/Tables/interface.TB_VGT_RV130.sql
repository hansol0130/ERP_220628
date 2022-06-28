USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_RV130](
	[PNR_SEQNO] [int] NOT NULL,
	[PAY_RQ_SEQNO] [int] NOT NULL,
	[DATA_FLAG] [varchar](10) NOT NULL,
	[PAY_MTH_CD] [varchar](12) NULL,
	[PAY_TOT_AMT] [int] NULL,
	[PAY_DTM] [varchar](14) NULL,
	[CARD_PAY_AMT] [int] NULL,
	[CARD_INSTLMT_CNT] [varchar](3) NULL,
	[CASH_PAY_AMT] [int] NULL,
	[CARD_KIND] [varchar](6) NULL,
	[CARD_NO] [varchar](4000) NULL,
	[DEPOSIT_BANK] [varchar](50) NULL,
	[DEPOSIT_ACNT_NO] [varchar](4000) NULL,
	[RMTR_NM] [varchar](100) NULL,
	[GCCT_POINT_KIND] [varchar](4) NULL,
	[GCCT_POINT_AMT] [int] NULL,
	[GCCT_NO] [varchar](200) NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
	[CARD_OWNER] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PNR_SEQNO] ASC,
	[PAY_RQ_SEQNO] ASC,
	[DATA_FLAG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_RV130] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 요청 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'PAY_RQ_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자료 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'DATA_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 방법 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'PAY_MTH_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급지불결제 총 금액판매가' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'PAY_TOT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'PAY_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 결제 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'CARD_PAY_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 할부 수' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'CARD_INSTLMT_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현금 결제 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'CASH_PAY_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 종류' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'CARD_KIND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'CARD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금 은행' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'DEPOSIT_BANK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금 계좌 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'DEPOSIT_ACNT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'송금자명' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'RMTR_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품권 포인트 종류' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'GCCT_POINT_KIND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품권 포인트 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'GCCT_POINT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품권 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'GCCT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 소유주' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130', @level2type=N'COLUMN',@level2name=N'CARD_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제요청' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV130'
GO
