USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_MASTER_SHINHAN](
	[ACCT_SEQ] [char](10) NOT NULL,
	[TR_DATE] [char](8) NOT NULL,
	[TR_DATE_SEQ] [char](10) NOT NULL,
	[TR_TIME] [char](6) NULL,
	[TR_AF_DATE] [char](8) NULL,
	[TR_IPJI_GBN] [char](1) NULL,
	[TR_AMT] [char](18) NULL,
	[TR_AF_AMT] [char](18) NULL,
	[BR_CD] [char](10) NULL,
	[BR_NM] [char](30) NULL,
	[JUKYO] [char](30) NULL,
	[NAEYONG] [char](30) NULL,
	[CMS_NB] [char](20) NULL,
	[CO_REG_NB] [char](10) NULL,
	[CO_NM] [char](50) NULL,
	[BANK_ID] [char](3) NULL,
	[BANK_NM] [char](20) NULL,
	[ACCT_NB] [char](20) NULL,
	[ACCT_TONGHWA] [char](3) NULL,
	[ACCT_NM] [char](100) NULL,
	[BALANCE] [char](18) NULL,
	[AMT_JI_AVAIL] [char](18) NULL,
	[LAST_TR_DATE] [char](8) NULL,
	[LAST_UPD_DATE] [char](8) NULL,
	[LAST_UPD_TIME] [char](6) NULL,
	[TRANSMIT_YN] [char](1) NULL,
	[ACCT_NICK] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ACCT_SEQ] ASC,
	[TR_DATE] ASC,
	[TR_DATE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'ACCT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'TR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래일자별일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'TR_DATE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'TR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'후송거래일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'TR_AF_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입출력거래구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'TR_IPJI_GBN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'TR_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래후잔액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'TR_AF_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래점코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'BR_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래점명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'BR_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적요' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'JUKYO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'NAEYONG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CMS번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'CMS_NB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌주사업자번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'CO_REG_NB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌주상호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'CO_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'은행코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'BANK_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'은행명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'BANK_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'ACCT_NB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통화코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'ACCT_TONGHWA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'ACCT_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌잔액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'BALANCE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌지급가능잔액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'AMT_JI_AVAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마지막거래일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'LAST_TR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마지막조회일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'LAST_UPD_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마지막조회시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'LAST_UPD_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN', @level2type=N'COLUMN',@level2name=N'TRANSMIT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'신한은행 거래내역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_SHINHAN'
GO
