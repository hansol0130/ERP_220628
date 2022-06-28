USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_ED100_LOG](
	[LOG_NO] [varchar](25) NOT NULL,
	[LOG_CREAT_FLAG] [varchar](1) NOT NULL,
	[ANCLY_SEQNO] [int] NOT NULL,
	[ANCLY_FLAG_CD] [varchar](5) NULL,
	[PNR_SEQNO] [int] NULL,
	[PAX_TATOO_NO] [varchar](5) NULL,
	[ITIN_TATOO_NO] [varchar](5) NULL,
	[SEG_TATOO_NO] [varchar](20) NULL,
	[SVC_TATOO_NO] [varchar](20) NULL,
	[SVC_AIR_CD] [varchar](2) NULL,
	[TSM_NO] [varchar](50) NULL,
	[TSM_AGT_CD] [varchar](10) NULL,
	[TSM_CREAT_ID] [varchar](50) NULL,
	[COMM_YN] [varchar](1) NULL,
	[RSV_STATUS_CD] [varchar](4) NULL,
	[ANCLY_CD] [varchar](10) NULL,
	[ANCLY_NM] [varchar](200) NULL,
	[ANCLY_DETAIL] [varchar](1000) NULL,
	[ROR_CD] [varchar](10) NULL,
	[CHRG_YN] [varchar](1) NULL,
	[ANCLY_AMT] [int] NULL,
	[ANCLY_TAX] [int] NULL,
	[RSV_DTM] [varchar](14) NULL,
	[CANCEL_DTM] [varchar](14) NULL,
	[PAY_TL_DTM] [varchar](14) NULL,
	[PAY_DTM] [varchar](14) NULL,
	[ISSUE_DTM] [varchar](14) NULL,
	[REFUND_RQ_DTM] [varchar](14) NULL,
	[REFUND_FINISH_DTM] [varchar](14) NULL,
	[EMD_PBLICTE_POSBL_YN] [varchar](1) NULL,
	[PAY_MTH_CD] [varchar](20) NULL,
	[EMD_TKT_NO] [varchar](50) NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
	[AIR_TTL] [varchar](14) NULL,
 CONSTRAINT [PK_TB_VGT_ED100_LOG] PRIMARY KEY CLUSTERED 
(
	[LOG_NO] ASC,
	[LOG_CREAT_FLAG] ASC,
	[ANCLY_SEQNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
