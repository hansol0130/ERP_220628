USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_RV410](
	[PNR_SEQNO] [int] NOT NULL,
	[DEPOSIT_REFUND_NO] [int] NOT NULL,
	[DATA_FLAG] [varchar](10) NOT NULL,
	[DEPOSIT_REFUND_DATE] [varchar](8) NULL,
	[ACNT_FLAG] [varchar](1) NULL,
	[DEPOSIT_FLAG] [varchar](4) NULL,
	[DETAIL_DEPOSIT_CD] [varchar](4) NULL,
	[DEPOSIT_REFUND_AMT] [int] NULL,
	[CARD_CONFM_NO] [varchar](10) NULL,
	[CONFM_USR_ID] [varchar](50) NULL,
	[CONFM_DTM] [varchar](14) NULL,
	[REMARK] [varchar](4000) NULL,
	[VAN_DELNG_ID] [varchar](50) NULL,
	[DEPOSIT_ACNT_NO] [varchar](4000) NULL,
	[RMTR_NM] [varchar](100) NULL,
	[CARD_NO] [varchar](4000) NULL,
	[INSTLMT_PERIOD] [int] NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[PNR_SEQNO] ASC,
	[DEPOSIT_REFUND_NO] ASC,
	[DATA_FLAG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_RV410] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금 환불 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'DEPOSIT_REFUND_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'데이터자료 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'DATA_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금 환불 일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'DEPOSIT_REFUND_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'ACNT_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'DEPOSIT_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세 입금 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'DETAIL_DEPOSIT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금 환불 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'DEPOSIT_REFUND_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 승인 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'CARD_CONFM_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'CONFM_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확인 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'CONFM_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'밴 거래 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'VAN_DELNG_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금 계좌 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'DEPOSIT_ACNT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'송금자명' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'RMTR_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'CARD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할부 기간' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'INSTLMT_PERIOD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금환불' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV410'
GO
