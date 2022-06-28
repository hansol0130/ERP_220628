USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_CUS_MEMBER_Rcvemail](
	[CUS_NO] [int] NOT NULL,
	[CUS_ID] [varchar](20) NULL,
	[CUS_PASS] [varchar](100) NULL,
	[CUS_STATE] [char](1) NULL,
	[CUS_NAME] [varchar](20) NOT NULL,
	[LAST_NAME] [varchar](20) NULL,
	[FIRST_NAME] [varchar](20) NULL,
	[NICKNAME] [varchar](20) NULL,
	[CUS_ICON] [int] NULL,
	[EMAIL] [varchar](40) NULL,
	[GENDER] [char](1) NULL,
	[SOC_NUM1] [varchar](6) NULL,
	[SOC_NUM2] [varchar](7) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[COM_TEL1] [varchar](6) NULL,
	[COM_TEL2] [varchar](5) NULL,
	[COM_TEL3] [varchar](4) NULL,
	[HOM_TEL1] [varchar](6) NULL,
	[HOM_TEL2] [varchar](5) NULL,
	[HOM_TEL3] [varchar](4) NULL,
	[FAX_TEL1] [varchar](6) NULL,
	[FAX_TEL2] [varchar](5) NULL,
	[FAX_TEL3] [varchar](4) NULL,
	[VISA_YN] [char](1) NULL,
	[PASS_YN] [char](1) NULL,
	[PASS_NUM] [varchar](20) NULL,
	[PASS_EXPIRE] [datetime] NULL,
	[PASS_ISSUE] [datetime] NULL,
	[NATIONAL] [char](2) NULL,
	[FOREIGNER_YN] [varchar](20) NULL,
	[CUS_GRADE] [int] NULL,
	[ETC] [nvarchar](max) NULL,
	[ETC2] [varchar](max) NULL,
	[BIRTHDAY] [datetime] NULL,
	[LUNAR_YN] [char](1) NULL,
	[RCV_EMAIL_YN] [char](1) NULL,
	[RCV_SMS_YN] [char](1) NULL,
	[ADDRESS1] [varchar](100) NULL,
	[ADDRESS2] [varchar](100) NULL,
	[ZIP_CODE] [varchar](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_MESSAGE] [varchar](50) NULL,
	[CXL_DATE] [datetime] NULL,
	[CXL_CODE] [char](7) NULL,
	[CXL_REMARK] [varchar](1000) NULL,
	[OLD_YN] [char](1) NULL,
	[CU_YY] [varchar](4) NULL,
	[CU_SEQ] [int] NULL,
	[RCV_DM_YN] [char](1) NULL,
	[POINT_CONSENT] [char](1) NULL,
	[POINT_CONSENT_DATE] [datetime] NULL,
	[sec_SOC_NUM2] [varbinary](16) NULL,
	[sec1_SOC_NUM2] [varchar](28) NULL,
	[sec_PASS_NUM] [varbinary](32) NULL,
	[sec1_PASS_NUM] [varchar](80) NULL,
	[VSOC_NUM] [char](13) NULL,
	[IPIN_DUP_INFO] [char](64) NULL,
	[IPIN_CONN_INFO] [char](88) NULL,
	[IPIN_ACC_DATE] [datetime] NULL,
	[TERMS2_YN] [char](1) NULL,
	[TERMS3_YN] [char](1) NULL,
	[SAFE_ID] [char](13) NULL,
	[BIRTH_DATE] [datetime] NULL,
	[OCB_AGREE_YN] [char](1) NULL,
	[OCB_AGREE_DATE] [datetime] NULL,
	[OCB_AGREE_EMP_CODE] [char](7) NULL,
	[OCB_CARD_NUM] [char](16) NULL,
	[JOIN_TYPE] [int] NULL,
	[CERT_YN] [char](1) NULL,
	[LAST_LOGIN_DATE] [datetime] NULL,
	[PHONE_AUTH_YN] [char](1) NULL,
	[PHONE_AUTH_DATE] [datetime] NULL,
	[SNS_MEM_YN] [char](1) NULL,
	[INFLOW_TYPE] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
