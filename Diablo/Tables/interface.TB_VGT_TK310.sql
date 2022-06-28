USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_TK310](
	[TASF_SEQNO] [int] NOT NULL,
	[AGT_CD] [varchar](10) NOT NULL,
	[PBLICTE_DATE] [varchar](8) NOT NULL,
	[TASF_NO] [varchar](13) NOT NULL,
	[AIR_NO_CD] [varchar](4) NULL,
	[TKT_NO] [varchar](20) NULL,
	[GDS_CD] [varchar](2) NULL,
	[ISSUE_DATE] [varchar](8) NULL,
	[IATA_NO] [varchar](10) NULL,
	[VOID_FLAG] [varchar](1) NULL,
	[PNR_NO] [varchar](10) NULL,
	[PAX_NM] [varchar](50) NULL,
	[CURR_CD] [varchar](3) NULL,
	[PAY_MTH_FLAG] [varchar](3) NULL,
	[CASH_AMT] [int] NULL,
	[CARD_AMT] [int] NULL,
	[TOT_AMT] [int] NULL,
	[CARD_NO] [varchar](200) NULL,
	[CARD_VALID_MMYY] [varchar](150) NULL,
	[CARD_CONFM_NO] [varchar](10) NULL,
	[CARD_INSTLMT_CNT] [varchar](3) NULL,
	[IATA_FEE] [int] NULL,
	[CARD_FEE] [int] NULL,
	[BRANCH_FLAG] [varchar](6) NULL,
	[REMARK] [varchar](4000) NULL,
	[REFUND_RCEPT_DATE] [varchar](8) NULL,
	[REFUND_TOT_AMT] [int] NULL,
	[REFUND_CARD_AMT] [int] NULL,
	[REFUND_CASH_AMT] [int] NULL,
	[REFUND_NETINCOME_AMT] [int] NULL,
	[REFUND_RCEPT_USR_ID] [varchar](50) NULL,
	[REFUND_REMARK] [varchar](150) NULL,
	[INICIS_DEPOSIT_AMT] [int] NULL,
	[PNR_SEQNO] [int] NULL,
	[PAX_NO] [int] NULL,
	[MNUL_REG_YN] [varchar](1) NULL,
	[PAY_SSPN_YN] [varchar](1) NULL,
	[BILL_SEQNO] [int] NULL,
	[E_TAX_BILL_NO] [varchar](100) NULL,
	[EXPREPOT_SEQNO] [int] NULL,
	[CHIT_SEQNO] [int] NULL,
	[FEE_TRANS_YN] [varchar](1) NULL,
	[TASF_PAY_DTM] [varchar](14) NULL,
	[TASF_REFUND_PAY_SSPN_YN] [varchar](1) NULL,
	[TASF_REFUND_BILL_SEQNO] [int] NULL,
	[TASF_REFUND_E_TAX_BILL_NO] [varchar](100) NULL,
	[TASF_REFUND_CHIT_SEQNO] [int] NULL,
	[TASF_REFUND_EXPREPOT_SEQNO] [int] NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
	[DSR_YN] [varchar](1) NULL,
	[LEGACY_TRANS_YN] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[TASF_SEQNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT ('KRW') FOR [CURR_CD]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT ('N') FOR [MNUL_REG_YN]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT ('N') FOR [PAY_SSPN_YN]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT ('N') FOR [TASF_REFUND_PAY_SSPN_YN]
GO
ALTER TABLE [interface].[TB_VGT_TK310] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취급수수료 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'AGT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발행 일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PBLICTE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취급수수료 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사 숫자 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'AIR_NO_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TKT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GDS 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'GDS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권 일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IATA 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'IATA_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'무효 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'VOID_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PNR_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'탑승객 명' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PAX_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화폐 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CURR_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제 방법 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PAY_MTH_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현금 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CASH_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TOT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 유효 월년' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_VALID_MMYY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 승인 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_CONFM_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 할부 수' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_INSTLMT_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IATA 수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'IATA_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CARD_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지점 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'BRANCH_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 접수 일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_RCEPT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 총 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_TOT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 카드 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_CARD_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 현금 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_CASH_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 순수입 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_NETINCOME_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 접수 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_RCEPT_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 비고' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REFUND_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이니시스 입금 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'INICIS_DEPOSIT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'탑승객 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PAX_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수동 등록 여부' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'MNUL_REG_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급 정지 여부' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'PAY_SSPN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계산서 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'BILL_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전자 세금 계산서 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'E_TAX_BILL_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결의서 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'EXPREPOT_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전표 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'CHIT_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료 전송 여부' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'FEE_TRANS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취급수수료 지급 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_PAY_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취급수수료 환불 지급 정지 여부' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_PAY_SSPN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취급수수료 환불 계산서 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_BILL_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취급수수료 환불 전자 세금 계산서 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_E_TAX_BILL_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취급수수료 환불 전표 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_CHIT_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취급수수료 환불 결의서 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'TASF_REFUND_EXPREPOT_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DSR 여부' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'DSR_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기간계 전송 여부' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK310', @level2type=N'COLUMN',@level2name=N'LEGACY_TRANS_YN'
GO
