USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_MASTER_damo](
	[RES_CODE] [char](12) NOT NULL,
	[PRICE_SEQ] [int] NULL,
	[SYSTEM_TYPE] [int] NOT NULL,
	[PROVIDER] [varchar](10) NULL,
	[MEDIUM_TYPE] [int] NULL,
	[AD_CODE] [varchar](50) NULL,
	[PRO_CODE] [varchar](20) NOT NULL,
	[PRO_NAME] [dbo].[PRO_NAME] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[PRO_TYPE] [int] NOT NULL,
	[RES_STATE] [int] NULL,
	[RES_TYPE] [int] NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[GRP_RES_CODE] [varchar](20) NULL,
	[CUS_NO] [int] NULL,
	[RES_NAME] [varchar](40) NOT NULL,
	[SOC_NUM1] [varchar](6) NULL,
	[RES_EMAIL] [varchar](100) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[ETC_TEL1] [varchar](6) NULL,
	[ETC_TEL2] [varchar](5) NULL,
	[ETC_TEL3] [varchar](4) NULL,
	[RES_ADDRESS1] [varchar](100) NULL,
	[RES_ADDRESS2] [varchar](100) NULL,
	[ZIP_CODE] [varchar](7) NULL,
	[MEMBER_YN] [char](1) NULL,
	[CUS_REQUEST] [nvarchar](4000) NULL,
	[CUS_RESPONSE] [nvarchar](1000) NULL,
	[ETC] [nvarchar](max) NULL,
	[TAX_YN] [char](1) NULL,
	[INSURANCE_YN] [char](1) NULL,
	[SENDING_REMARK] [nvarchar](1000) NULL,
	[MOV_BEFORE_CODE] [varchar](20) NULL,
	[MOV_AFTER_CODE] [varchar](20) NULL,
	[MOV_DATE] [datetime] NULL,
	[COMM_RATE] [numeric](4, 2) NULL,
	[LAST_PAY_DATE] [datetime] NULL,
	[PNR_INFO] [varchar](max) NULL,
	[RES_PRO_TYPE] [int] NULL,
	[SALE_COM_CODE] [varchar](50) NULL,
	[SALE_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[SALE_TEAM_CODE] [varchar](3) NULL,
	[SALE_TEAM_NAME] [varchar](50) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_TEAM_CODE] [varchar](3) NULL,
	[NEW_TEAM_NAME] [varchar](50) NULL,
	[PROFIT_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[PROFIT_TEAM_CODE] [varchar](3) NULL,
	[PROFIT_TEAM_NAME] [varchar](50) NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[CXL_DATE] [datetime] NULL,
	[CXL_CODE] [char](7) NULL,
	[CXL_TYPE] [int] NULL,
	[REFUNDMENT_BANK] [varchar](100) NULL,
	[REFUNDMENT_NAME] [varchar](100) NULL,
	[REFUNDMENT_BANKCODE] [varchar](100) NULL,
	[REFUNDMENT_STATUS] [char](2) NULL,
	[CFM_DATE] [datetime] NULL,
	[CFM_CODE] [dbo].[EMP_CODE] NULL,
	[CARD_PROVE] [varchar](4000) NULL,
	[COMM_AMT] [decimal](18, 0) NULL,
	[row_id] [uniqueidentifier] NULL,
	[sec_SOC_NUM2] [varbinary](16) NULL,
	[sec1_SOC_NUM2] [varchar](28) NULL,
	[IPIN_DUP_INFO] [char](64) NULL,
	[AGT_REMARK] [nvarchar](max) NULL,
	[VIEW_YN] [char](1) NULL,
	[GENDER] [char](1) NULL,
	[BIRTH_DATE] [datetime] NULL,
	[PASS_RECEIVE_END_YN] [char](1) NULL,
 CONSTRAINT [PK_RES_MASTER] PRIMARY KEY NONCLUSTERED 
(
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_MASTER_damo] ADD  CONSTRAINT [DF_RES_MASTER_COMM_RATE]  DEFAULT ((0)) FOR [COMM_RATE]
GO
ALTER TABLE [dbo].[RES_MASTER_damo] ADD  CONSTRAINT [DF_RES_MASTER_COMM_AMT]  DEFAULT ((0)) FOR [COMM_AMT]
GO
ALTER TABLE [dbo].[RES_MASTER_damo] ADD  CONSTRAINT [RES_MASTER_df_rowid]  DEFAULT (newid()) FOR [row_id]
GO
ALTER TABLE [dbo].[RES_MASTER_damo] ADD  DEFAULT ('Y') FOR [VIEW_YN]
GO
ALTER TABLE [dbo].[RES_MASTER_damo] ADD  DEFAULT ('N') FOR [PASS_RECEIVE_END_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : WEB, 2 : ERP, 3 : Mobile (  None = 0 , WEB = 1, ERP = 2, Mobile = 3 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SYSTEM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NONE=0, ??????=1, ???????????????=2, ???????????????=3, ?????????=4, ?????????=5, ?????????????????????=6, ?????????????????????=7, LandyOnly=8, ????????????=9, ??????TnE=10, ????????????=11, ????????????_????????????=12, ????????????_??????=13, G??????=14, ????????????=15, ???????????????=16, ????????????=17, ???????????????=18, ????????????=19, ????????????=20, ???????????????=21, ?????????_??????=22, ?????????_??????=23, ????????????=24, CBS??????=25, ??????????????????=26, ??????????????????_??????=27, ??????????????????_????????????=28, ????????????=29, KB????????????=30, ????????????=31, ??????=32, BTMS=33, ????????????=34, BTMS_?????????=35, ???????????????=36, ????????????=37, ??????=38, NH??????=39, ???????????????=40, ?????????=41, ?????????=90' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PROVIDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'( ??????=1, ??????=2, ?????????=3, ??????=4, ?????????=5, ?????????=6 ,SMS=7 ,EMAIL=8 )  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MEDIUM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'AD_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : ????????? ??????, 2 : ??????, 3 : ??????, 4 : ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'( ?????? = 0, ??????????????????=1, ????????????=2, ?????????=3, ????????????=4, ????????????=5, ?????????=6, ??????=7, ??????=8, ??????=9, ?????? = 10 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RES_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' ( ?????? = 0, ????????? = 1, ?????? = 2, ?????? = 9, ?????? = 10  ) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RES_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GRP_RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RES_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SOC_NUM1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RES_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ETC_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ETC_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ETC_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RES_ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RES_ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MEMBER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CUS_REQUEST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CUS_RESPONSE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ETC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TAX_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INSURANCE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SENDING_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MOV_BEFORE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MOV_AFTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MOV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'COMM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'LAST_PAY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PNR_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????? ( ?????? = 1, ??????=2, ??????=3, ??????=4 )  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RES_PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SALE_COM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SALE_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SALE_TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SALE_TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PROFIT_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PROFIT_TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PROFIT_TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 ????????????(??????, ????????????) 2 ???????????? 3 ???????????? 4 ?????????????????? 5 ??????,?????? 6 ?????????????????? 7 ???????????? 8 ????????????(????????????) 9 ?????????????????? 10 ?????????????????? 11 ???????????????????????? 12 ????????? ?????? 13 ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'REFUNDMENT_BANK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'REFUNDMENT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'REFUNDMENT_BANKCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'REFUNDMENT_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CFM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CFM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CARD_PROVE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'COMM_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'row_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????_???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'sec_SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????_???????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'sec1_SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????DI???' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'IPIN_DUP_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'AGT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'VIEW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PASS_RECEIVE_END_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_damo'
GO
