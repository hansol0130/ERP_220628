USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_MASTER_damo](
	[PAY_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[PAY_TYPE] [int] NULL,
	[PAY_SUB_TYPE] [varchar](50) NULL,
	[PAY_SUB_NAME] [varchar](50) NULL,
	[AGT_CODE] [varchar](10) NULL,
	[ACC_SEQ] [int] NULL,
	[PAY_METHOD] [int] NULL,
	[PAY_NAME] [varchar](80) NULL,
	[PAY_PRICE] [int] NULL,
	[COM_RATE] [decimal](4, 2) NULL,
	[COM_PRICE] [decimal](12, 2) NULL,
	[PAY_DATE] [datetime] NULL,
	[PAY_REMARK] [varchar](200) NULL,
	[ADMIN_REMARK] [varchar](300) NULL,
	[CUS_NO] [dbo].[CUS_NO] NULL,
	[INSTALLMENT] [int] NULL,
	[EDI_CODE] [varchar](10) NULL,
	[CLOSED_CODE] [char](7) NULL,
	[CLOSED_YN] [char](1) NULL,
	[CLOSED_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[CXL_YN] [dbo].[USE_N] NULL,
	[CXL_DATE] [dbo].[CANCEL_DATE] NULL,
	[CXL_CODE] [dbo].[CANCEL_CODE] NULL,
	[sec_PAY_NUM] [varbinary](112) NULL,
	[sec1_PAY_NUM] [varchar](400) NULL,
	[PG_APP_NO] [varchar](20) NULL,
	[MALL_ID] [varchar](10) NULL,
 CONSTRAINT [PK_PAY_MASTER] PRIMARY KEY CLUSTERED 
(
	[PAY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAY_MASTER_damo] ADD  CONSTRAINT [DF__PAY_MASTE__COM_P__63E3BB6D]  DEFAULT ((0)) FOR [COM_PRICE]
GO
ALTER TABLE [dbo].[PAY_MASTER_damo] ADD  CONSTRAINT [DF__PAY_MASTE__CLOSE__62EF9734]  DEFAULT ('N') FOR [CLOSED_YN]
GO
ALTER TABLE [dbo].[PAY_MASTER_damo] ADD  CONSTRAINT [DEF_PAY_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[PAY_MASTER_damo] ADD  CONSTRAINT [DEF_PAY_MASTER_CXL_YN]  DEFAULT ('N') FOR [CXL_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 은행, 1 : 일반계좌, 2 : OFF신용카드, 3 : PG신용카드, 4 : 상품권, 5 : 현금, 6 : 미수대체, 7 : 포인트_회원가입, 8 : 기타, 9 : 세금계산서, 10 : CCCF, 11 : IND_TKT, 12 : TASF, 13 : ARS, 14 : ARS호전환, 15 : 가상계좌, 16 : 네이버페이_신용카드, 17 : 네이버페이_계좌이체, 18 : 네이버페이_포인트, 19 : SMSPay, 71 : 포인트_구매실적, 999 : 없음' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금세부구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_SUB_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금세부구분명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_SUB_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ACC_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(0 : 홈페이지, 1 : EMAI,L 2 : 직접방문, 3 : 전화, 4 : 은행) ( 홈페이지 = 0, EMAIL = 1, 직접방문 = 2, 전화 = 3 , 은행 = 4, 수동 = 8, 시스템 = 9 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_METHOD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'COM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'COM_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ADMIN_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할부개월수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INSTALLMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전자결제문서번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금마감자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CLOSED_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금마감여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CLOSED_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금마감일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CLOSED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제번호_암호화필드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'sec_PAY_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제번호_암호화필드2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'sec1_PAY_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PG승인번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PG_APP_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'몰ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MALL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo'
GO
