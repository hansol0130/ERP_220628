USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_TMP_NUMBER_YES_ETC_2](
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
	[PASS_EXPIRE] [datetime] NULL,
	[PASS_ISSUE] [datetime] NULL,
	[NATIONAL] [char](2) NULL,
	[FOREIGNER_YN] [varchar](20) NULL,
	[CUS_GRADE] [int] NULL,
	[ETC] [nvarchar](max) NULL,
	[ETC2] [nvarchar](max) NULL,
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
	[SOC_NUM2] [varchar](7) NULL,
	[PASS_NUM] [varchar](20) NULL,
	[VSOC_NUM] [char](13) NULL,
	[IPIN_DUP_INFO] [char](64) NULL,
	[IPIN_CONN_INFO] [char](88) NULL,
	[IPIN_ACC_DATE] [datetime] NULL,
	[PASS_DATE] [datetime] NULL,
	[PASS_EMP_CODE] [char](7) NULL,
	[FAX_SEQ] [char](17) NULL,
	[EMAIL_AGREE_DATE] [datetime] NULL,
	[SMS_AGREE_DATE] [datetime] NULL,
	[EMAIL_INFLOW_TYPE] [varchar](2) NULL,
	[SMS_INFLOW_TYPE] [varchar](2) NULL,
	[RCV_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[SAFE_ID] [char](13) NULL,
	[BIRTH_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
