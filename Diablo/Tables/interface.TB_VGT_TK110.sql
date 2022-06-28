USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_TK110](
	[AGT_CD] [varchar](10) NOT NULL,
	[TKT_NO] [varchar](20) NOT NULL,
	[ISSUE_DATE] [varchar](8) NOT NULL,
	[PNR_SEQNO] [int] NULL,
	[PAX_NO] [int] NULL,
	[VOID_FLAG] [varchar](20) NULL,
	[CONJ_TKT_FLAG] [varchar](1) NULL,
	[AIR_NO_CD] [varchar](4) NULL,
	[AIR_CD] [varchar](2) NULL,
	[CONJ_TKT_NO] [varchar](20) NULL,
	[PAX_ENG_FMNM] [varchar](50) NULL,
	[PAX_ENG_NM] [varchar](50) NULL,
	[FARE] [int] NULL,
	[DSCNT_AMT] [int] NULL,
	[NET_AMT] [int] NULL,
	[CASH_AMT] [int] NULL,
	[CARD_AMT] [int] NULL,
	[TAX_AMT] [int] NULL,
	[FEE] [int] NULL,
	[FEE_VAT] [int] NULL,
	[SALE_AMT] [int] NULL,
	[ITIN_DEP_DATE] [varchar](8) NULL,
	[REG_USR_ID] [varchar](50) NOT NULL,
	[REG_DTM] [varchar](14) NOT NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
	[CARD_NO] [varchar](4000) NULL,
	[CARD_INSTLMT_CNT] [varchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[AGT_CD] ASC,
	[TKT_NO] ASC,
	[ISSUE_DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_TK110] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'AGT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'TKT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'탑승객 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'PAX_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'무효 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'VOID_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연결 티켓 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'CONJ_TKT_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사 숫자코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'AIR_NO_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'AIR_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연결 티켓 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'CONJ_TKT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'탑승객 영문 성' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'PAX_ENG_FMNM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'탑승객 영문 명' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'PAX_ENG_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요금운임' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'FARE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'DSCNT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네트 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'NET_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현금 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'CASH_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'CARD_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세금 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'TAX_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'FEE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료 부가가치세' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'FEE_VAT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매 금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'SALE_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여정 출발 일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'ITIN_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'CARD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드 할부 수' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110', @level2type=N'COLUMN',@level2name=N'CARD_INSTLMT_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권티켓' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_TK110'
GO
