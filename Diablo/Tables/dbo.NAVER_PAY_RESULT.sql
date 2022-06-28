USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PAY_RESULT](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[NPAY_ID] [varchar](50) NULL,
	[NPAY_HIS_ID] [varchar](50) NULL,
	[LAST_STATUS] [varchar](10) NULL,
	[RESULT_CODE] [varchar](20) NULL,
	[RESULT_MSG] [varchar](100) NULL,
	[CUS_NO] [int] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[PAY_MEANS] [varchar](10) NULL,
	[TOTAL_PRICE] [int] NULL,
	[PAY_PRICE] [int] NULL,
	[PAY_POINT] [int] NULL,
	[CARD_CODE] [varchar](10) NULL,
	[CARD_NO] [varchar](50) NULL,
	[CARD_AUTH_NO] [varchar](30) NULL,
	[INST_NO] [int] NULL,
	[BANK_CODE] [varchar](10) NULL,
	[BANK_NUM] [varchar](50) NULL,
	[PAY_DATE] [datetime] NULL,
	[MALL_ID] [varchar](50) NULL,
	[NEW_DATE] [datetime] NULL,
	[REMARK] [varchar](1000) NULL,
	[USER_AGENT] [varchar](1000) NULL,
	[RESULT_TEXT] [varchar](1000) NULL,
	[PAY_SEQ] [int] NULL,
	[POINT_PAY_SEQ] [int] NULL,
 CONSTRAINT [PK_NAVER_PAY_RESULT] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버페이결제번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'NPAY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버페이결제이력번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'NPAY_HIS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최종결제상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'LAST_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결과코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'RESULT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결과메세지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'RESULT_MSG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주결제타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'PAY_MEANS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총결제금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'TOTAL_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'PAY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트결제금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'PAY_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'CARD_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'CARD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드승인번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'CARD_AUTH_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할부개월수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'INST_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'은행코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'BANK_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'은행계좌번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'BANK_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'PAY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가맹점코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'MALL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제기기정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'USER_AGENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제결과안내' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'RESULT_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'PAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트결제번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT', @level2type=N'COLUMN',@level2name=N'POINT_PAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버페이결과값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PAY_RESULT'
GO
