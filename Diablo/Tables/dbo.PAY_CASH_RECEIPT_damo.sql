USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_CASH_RECEIPT_damo](
	[RECEIPT_NO] [int] IDENTITY(1,1) NOT NULL,
	[RES_CODE] [char](12) NULL,
	[CUS_NO] [int] NULL,
	[CUS_NAME] [varchar](20) NULL,
	[SOC_NUM1] [varchar](6) NULL,
	[NOR_TEL1] [varchar](3) NULL,
	[NOR_TEL2] [varchar](4) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[CPN_NUM1] [varchar](3) NULL,
	[CPN_NUM2] [varchar](2) NULL,
	[CPN_NUM3] [varchar](5) NULL,
	[TARGET_USE] [int] NULL,
	[TARGET_PRICE] [int] NULL,
	[APPROVAL_NO] [varchar](30) NULL,
	[APPROVAL_SEQ] [varchar](30) NULL,
	[REPLY_CODER] [varchar](5) NULL,
	[APPROVAL_DATE] [datetime] NULL,
	[RECEIPT_STATE] [int] NULL,
	[REMARK] [varchar](4000) NULL,
	[NEW_CODE] [int] NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[sec_SOC_NUM2] [varbinary](16) NULL,
	[AGT_CODE] [varchar](10) NULL,
	[CXL_REPLY_CODER] [varchar](5) NULL,
	[CXL_CODE] [dbo].[EMP_CODE] NULL,
	[CXL_DATE] [datetime] NULL,
	[CXL_REMARK] [varchar](500) NULL,
	[CXL_TYPE] [int] NULL,
	[PG_NO] [varchar](30) NULL,
	[RECEIPT_TYPE] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[RECEIPT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현금영수증번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'RECEIPT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'SOC_NUM1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사업자번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CPN_NUM1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사업자번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CPN_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사업자번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CPN_NUM3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'용도 ( 0 : 소비자(소득공제용), 1 : 사업자(지출증빙용))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'TARGET_USE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'신청금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'TARGET_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'APPROVAL_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인SEQ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'APPROVAL_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'응답코더' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'REPLY_CODER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'APPROVAL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 미신청, 1 : 발행, 2 : 취소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'RECEIPT_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호_암호화필드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'sec_SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소응답타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CXL_REPLY_CODER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CXL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소타입( 1 : 거래취소, 2 : 오류발급취소, 3 : 기타)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'CXL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PG거래번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'PG_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : KICC, 1 : EASYPAY (0 : 기존모듈, 1 : 신규모듈)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo', @level2type=N'COLUMN',@level2name=N'RECEIPT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현금영수증' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CASH_RECEIPT_damo'
GO
