USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_CUSTOMER_HISTORY](
	[CUS_NO] [int] NOT NULL,
	[HIS_NO] [int] NOT NULL,
	[CUS_ID] [varchar](20) NULL,
	[CUS_NAME] [varchar](20) NULL,
	[BIRTH_DATE] [datetime] NULL,
	[GENDER] [char](1) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[EMAIL] [varchar](40) NULL,
	[CUS_GRADE] [int] NULL,
	[IPIN_DUP_INFO] [char](64) NULL,
	[IPIN_CONN_INFO] [char](88) NULL,
	[LAST_NAME] [varchar](20) NULL,
	[FIRST_NAME] [varchar](20) NULL,
	[NICKNAME] [varchar](20) NULL,
	[RCV_EMAIL_YN] [char](1) NULL,
	[RCV_SMS_YN] [char](1) NULL,
	[CUS_PASS] [varchar](100) NULL,
	[CUS_STATE] [char](1) NULL,
	[COM_TEL1] [varchar](6) NULL,
	[COM_TEL2] [varchar](5) NULL,
	[COM_TEL3] [varchar](4) NULL,
	[HOM_TEL1] [varchar](6) NULL,
	[HOM_TEL2] [varchar](5) NULL,
	[HOM_TEL3] [varchar](4) NULL,
	[NATIONAL] [char](2) NULL,
	[FOREIGNER_YN] [varchar](20) NULL,
	[ADDRESS1] [varchar](100) NULL,
	[ADDRESS2] [varchar](100) NULL,
	[ZIP_CODE] [varchar](7) NULL,
	[POINT_CONSENT] [char](1) NULL,
	[POINT_CONSENT_DATE] [datetime] NULL,
	[JOIN_TYPE] [int] NULL,
	[CERT_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[EMP_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_REMARK] [varchar](100) NULL,
	[SYSTEM_TYPE] [int] NULL,
	[EDT_TYPE] [int] NULL,
 CONSTRAINT [PK_CUS_CUSTOMER_HISTORY] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC,
	[HIS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
