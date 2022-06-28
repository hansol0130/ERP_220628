USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_TK120](
	[AGT_CD] [varchar](10) NOT NULL,
	[ISSUE_DATE] [varchar](8) NOT NULL,
	[TKT_NO] [varchar](20) NOT NULL,
	[PNR_SEQNO] [int] NULL,
	[REFUND_FARE] [int] NULL,
	[USE_FARE] [int] NULL,
	[REFUND_CANCEL_FEE_FLAG] [varchar](1) NULL,
	[REFUND_CANCEL_FEE] [int] NULL,
	[REFUND_CASH_AMT] [int] NULL,
	[REFUND_CARD_AMT] [int] NULL,
	[REFUND_TAX_AMT] [int] NULL,
	[FOP_FLAG] [varchar](2) NULL,
	[CARD_NO] [varchar](4000) NULL,
	[ESAC] [varchar](20) NULL,
	[RCEPT_DATE] [varchar](8) NULL,
	[REFUND_AMT] [int] NULL,
	[REFUND_FLAG] [varchar](1) NULL,
	[AGT_BSP_CASH_CANCEL_FEE] [int] NULL,
	[AGT_BSP_CARD_CANCEL_FEE] [int] NULL,
	[AGT_BSP_REFUND_AMT] [int] NULL,
	[AIR_FEE] [int] NULL,
	[AGT_FEE] [int] NULL,
	[AGT_REFUND_XPTN_AMT] [int] NULL,
	[CUST_REFUND_AMT] [int] NULL,
	[CUST_ACNT_NO] [varchar](4000) NULL,
	[BANK_CD] [varchar](19) NULL,
	[DPSTR_NM] [varchar](100) NULL,
	[REFUND_AGT_FEE] [int] NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[AGT_CD] ASC,
	[ISSUE_DATE] ASC,
	[TKT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_TK120] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'AGT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'TKT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 운임요금' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_FARE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용 운임요금' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'USE_FARE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 취소 수수료 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_CANCEL_FEE_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 취소 수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_CANCEL_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 현금 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_CASH_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 카드 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_CARD_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 세금 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_TAX_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지불방법 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'FOP_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 번호숫자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'CARD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전자지불승인번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'ESAC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'접수 일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'RCEPT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사 공동결제방식(BSP) 현금 취소 수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'AGT_BSP_CASH_CANCEL_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사 공동결제방식(BSP) 카드 취소 수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'AGT_BSP_CARD_CANCEL_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사에이전트 공동결제방식(BSP) 환불 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'AGT_BSP_REFUND_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사 수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'AIR_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사 수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'AGT_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사 환불 예상 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'AGT_REFUND_XPTN_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객 환불 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'CUST_REFUND_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객 계좌계정 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'CUST_ACNT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'은행 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'BANK_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예금주 명' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'DPSTR_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불 여행사 수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REFUND_AGT_FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권티켓환불' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK120'
GO
