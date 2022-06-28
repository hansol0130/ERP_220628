USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI_MASTER_damo](
	[EDI_CODE] [dbo].[EDI_CODE] NOT NULL,
	[DOC_TYPE] [dbo].[PUB_CODE] NULL,
	[DETAIL_TYPE] [varchar](10) NULL,
	[DETAIL_NAME] [varchar](20) NULL,
	[EDI_STATUS] [char](1) NULL,
	[REF_CODE] [dbo].[EDI_CODE] NULL,
	[RCV_TEAM_CODE] [dbo].[TEAM_CODE] NULL,
	[APP_TYPE] [char](1) NULL,
	[SUBJECT] [varchar](100) NOT NULL,
	[CONTENTS] [nvarchar](max) NOT NULL,
	[FILE1] [varchar](255) NULL,
	[FILE2] [varchar](255) NULL,
	[FILE3] [varchar](255) NULL,
	[OFF_DOCUMENT] [varchar](200) NULL,
	[JOIN_DATE] [datetime] NULL,
	[OUT_DATE] [datetime] NULL,
	[VAC_DAY] [numeric](18, 1) NULL,
	[PRICE] [decimal](12, 0) NULL,
	[CURRENCY] [char](3) NULL,
	[EXC_RATE] [numeric](18, 1) NULL,
	[PAY_BANK] [varchar](20) NULL,
	[PAY_RECEIPT] [varchar](20) NULL,
	[TERM_PAYMENT] [smalldatetime] NULL,
	[RCV_CODE] [dbo].[EMP_CODE] NULL,
	[RCV_YN] [char](1) NULL,
	[RCV_DATE] [smalldatetime] NULL,
	[RCV_REMARK] [varchar](max) NULL,
	[VIEW_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_NAME] [dbo].[KOR_NAME] NULL,
	[NEW_TEAM_NAME] [varchar](50) NULL,
	[NEW_DUTY_NAME] [dbo].[DUTY_NAME] NULL,
	[NEW_POS_NAME] [dbo].[POS_NAME] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[BIRTH_DATE] [smalldatetime] NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[PRO_TYPE] [int] NULL,
	[REAL_PRICE] [decimal](12, 0) NULL,
	[RES_CODE] [varchar](12) NULL,
	[AGT_CODE] [varchar](10) NULL,
	[PAY_SEQ] [int] NULL,
	[FOLDER_TYPE] [int] NULL,
	[row_id] [uniqueidentifier] NULL,
	[sec_PAY_ACCOUNT] [varbinary](32) NULL,
 CONSTRAINT [PK_EDI_MASTER] PRIMARY KEY CLUSTERED 
(
	[EDI_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_MASTER_damo] ADD  CONSTRAINT [DEF_EDI_MASTER_EDI_STATUS]  DEFAULT ((1)) FOR [EDI_STATUS]
GO
ALTER TABLE [dbo].[EDI_MASTER_damo] ADD  CONSTRAINT [DEF_EDI_MASTER_APP_TYPE]  DEFAULT ((1)) FOR [APP_TYPE]
GO
ALTER TABLE [dbo].[EDI_MASTER_damo] ADD  CONSTRAINT [DEF_EDI_MASTER_RCV_YN]  DEFAULT ('N') FOR [RCV_YN]
GO
ALTER TABLE [dbo].[EDI_MASTER_damo] ADD  CONSTRAINT [DEF_EDI_MASTER_VIEW_YN]  DEFAULT ('Y') FOR [VIEW_YN]
GO
ALTER TABLE [dbo].[EDI_MASTER_damo] ADD  CONSTRAINT [DEF_EDI_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[EDI_MASTER_damo] ADD  CONSTRAINT [DEF_EDI_MASTER_FOLDER_TYPE]  DEFAULT ((0)) FOR [FOLDER_TYPE]
GO
ALTER TABLE [dbo].[EDI_MASTER_damo] ADD  CONSTRAINT [EDI_MASTER_df_rowid]  DEFAULT (newid()) FOR [row_id]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'휴가 = 1, 출장 = 2,  기안 = 3, 일반지결 = 4, 업무협조문 = 5, 발권요청서 = 6, 관리부문경유기안 = 7, 행사지결 = 8, 출장보고서 = 9)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_MASTER_damo', @level2type=N'COLUMN',@level2name=N'DOC_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'진행 = 1, 재검토 = 2, 완료 = 3 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDI_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' ( 후불대기함 = 1, 미수대기함 =2 , 당일출금함 =3 , 법인카드대기함 = 4, 출금함15일 = 5, 외화송금함 = 6, 대체지결함 =7, 일반대기함 = 98, 기타 = 99 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FOLDER_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_MASTER_damo'
GO
