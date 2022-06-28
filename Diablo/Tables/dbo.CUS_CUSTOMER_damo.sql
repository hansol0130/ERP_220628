USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_CUSTOMER_damo](
	[CUS_NO] [int] IDENTITY(1,1) NOT NULL,
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
	[PASS_DATE] [datetime] NULL,
	[PASS_EMP_CODE] [char](7) NULL,
	[FAX_SEQ] [char](17) NULL,
	[EMAIL_AGREE_DATE] [datetime] NULL,
	[SMS_AGREE_DATE] [datetime] NULL,
	[EMAIL_INFLOW_TYPE] [varchar](2) NULL,
	[SMS_INFLOW_TYPE] [varchar](2) NULL,
	[RCV_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[SAFE_ID] [char](13) NULL,
	[BIRTH_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_CUSTOMER_damo] ADD  CONSTRAINT [DEF_CUS_CUSTOMER_CUS_STATE]  DEFAULT ('Y') FOR [CUS_STATE]
GO
ALTER TABLE [dbo].[CUS_CUSTOMER_damo] ADD  CONSTRAINT [DF_CUS_CUSTOMER_CUS_GRADE]  DEFAULT ((0)) FOR [CUS_GRADE]
GO
ALTER TABLE [dbo].[CUS_CUSTOMER_damo] ADD  CONSTRAINT [DF_CUS_CUSTOMER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[CUS_CUSTOMER_damo] ADD  CONSTRAINT [DF_CUS_CUSTOMER_OLD_YN]  DEFAULT ('N') FOR [OLD_YN]
GO
ALTER TABLE [dbo].[CUS_CUSTOMER_damo] ADD  CONSTRAINT [DF_CUS_CUSTOMER_RCV_DM_YN]  DEFAULT ('N') FOR [RCV_DM_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비밀번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_PASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y : 가입, N : 탈퇴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'닉네임' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NICKNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이콘' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_ICON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성별' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SOC_NUM1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'COM_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'COM_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'COM_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'집연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'HOM_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'집연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'HOM_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'집연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'HOM_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FAX_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FAX_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FAX_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비자여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'VISA_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PASS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권만료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PASS_EXPIRE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권발급일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PASS_ISSUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국적' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NATIONAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'외국인여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FOREIGNER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : NEW, 1 : FAMILY, 2 : BEST, 3 : TOP, 4 : VIP, 5 : VVIP, 9 : 전체  --> (  일반 = 0, 그린 = 2, 블루 = 4, 퍼플 = 6, 블랙 = 8, 전체 = 9  ) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'ETC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전예약' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'ETC2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'BIRTHDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'음력여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'LUNAR_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일 수신여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'RCV_EMAIL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS수신여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'RCV_SMS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EDT_MESSAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CXL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전회원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'OLD_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전가입년도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CU_YY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전가입순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'dm발송여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'RCV_DM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'POINT_CONSENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트동의일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'POINT_CONSENT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호뒷자리_암호화필드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'sec_SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호뒷자리_암호화필드2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'sec1_SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권번호_암호화필드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'sec_PASS_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권번호_암호화필드2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'sec1_PASS_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가상주민번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'VSOC_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호DI값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'IPIN_DUP_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호CI값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'IPIN_CONN_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이핀전환동의일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'IPIN_ACC_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권인증일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PASS_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권인증자사번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PASS_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권인증팩스번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FAX_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일수신동의날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EMAIL_AGREE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS수신동의날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SMS_AGREE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일수신동의구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EMAIL_INFLOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS수신동의구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SMS_INFLOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신동의수정 사번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'RCV_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원 안심키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SAFE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일_주민번호기준' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객통합정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_CUSTOMER_damo'
GO
