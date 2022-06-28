USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_MEMBER_SLEEP](
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
	[INFLOW_TYPE] [int] NULL,
	[FORMEMBER_YN] [char](1) NULL,
	[FORMEMBER_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_MEMBER_SLEEP] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_MEMBER_SLEEP]  WITH CHECK ADD  CONSTRAINT [FK_CUS_MEMBER_CUS_MEMBER_SLEEP] FOREIGN KEY([CUS_NO])
REFERENCES [dbo].[CUS_MEMBER] ([CUS_NO])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUS_MEMBER_SLEEP] CHECK CONSTRAINT [FK_CUS_MEMBER_CUS_MEMBER_SLEEP]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CUS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비밀번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CUS_PASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CUS_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'닉네임' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'NICKNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이콘' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CUS_ICON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성별' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'SOC_NUM1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'COM_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'COM_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'COM_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'집연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'HOM_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'집연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'HOM_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'집연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'HOM_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'FAX_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'FAX_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'FAX_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비자여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'VISA_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'PASS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'PASS_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권만료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'PASS_EXPIRE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권발급일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'PASS_ISSUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국적' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'NATIONAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'외국인여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'FOREIGNER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객등급 ( 0 : 일반, 2 : 그린, 4 : 블루, 6 : 퍼플, 8 : 블랙, 9 : 전체 ) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CUS_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ETC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'ETC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ETC2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'ETC2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'BIRTHDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'음력여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'LUNAR_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일수신여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'RCV_EMAIL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS수신여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'RCV_SMS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'EDT_MESSAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CXL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전회원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'OLD_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전가입년도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CU_YY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전가입순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DM발송여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'RCV_DM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'POINT_CONSENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트동의일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'POINT_CONSENT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가상주민번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'VSOC_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호DI값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'IPIN_DUP_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호CI값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'IPIN_CONN_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이핀전환동의일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'IPIN_ACC_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'개인정보활용동의2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'TERMS2_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'개인정보활용동의3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'TERMS3_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호안심키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'SAFE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일_주민번호기입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OK캐쉬백동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'OCB_AGREE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OK캐쉬백전환동의날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'OCB_AGREE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OK캐쉬백전환동의사번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'OCB_AGREE_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OK캐쉬백카드번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'OCB_CARD_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원가입구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'JOIN_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인증여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'CERT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최근로그인일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'LAST_LOGIN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰인증여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'PHONE_AUTH_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰인증날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'PHONE_AUTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SNS회원가입여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'SNS_MEM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원가입유입처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'INFLOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평생회원유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'FORMEMBER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평생회원날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP', @level2type=N'COLUMN',@level2name=N'FORMEMBER_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'휴면회원정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_MEMBER_SLEEP'
GO
