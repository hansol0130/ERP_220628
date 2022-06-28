USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_MASTER_DAMO_BACKUP](
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
	[PASS_RECEIVE_END_YN] [char](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO