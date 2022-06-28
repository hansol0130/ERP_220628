USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMP_MASTER_damo](
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[KOR_NAME] [dbo].[KOR_NAME] NOT NULL,
	[ENG_FIRST_NAME] [dbo].[ENG_FIRST_NAME] NULL,
	[ENG_LAST_NAME] [dbo].[ENG_LAST_NAME] NULL,
	[SOC_NUMBER1] [char](6) NULL,
	[GENDER] [char](1) NOT NULL,
	[PASSWORD] [varchar](100) NULL,
	[TEAM_CODE] [dbo].[TEAM_CODE] NOT NULL,
	[GROUP_CODE] [dbo].[GROUP_CODE] NULL,
	[WORK_TYPE] [int] NULL,
	[DUTY_TYPE] [int] NULL,
	[POS_TYPE] [int] NULL,
	[JOIN_TYPE] [int] NULL,
	[JOIN_DATE] [smalldatetime] NULL,
	[OUT_DATE] [smalldatetime] NULL,
	[EMAIL] [varchar](30) NULL,
	[EMAIL_PASSWORD] [varchar](30) NULL,
	[MESSENGER] [varchar](30) NULL,
	[INNER_NUMBER1] [varchar](4) NULL,
	[INNER_NUMBER2] [varchar](4) NULL,
	[INNER_NUMBER3] [varchar](4) NULL,
	[ZIP_CODE] [char](7) NOT NULL,
	[ADDRESS1] [varchar](50) NULL,
	[ADDRESS2] [varchar](80) NULL,
	[TEL_NUMBER1] [varchar](4) NULL,
	[TEL_NUMBER2] [varchar](4) NULL,
	[TEL_NUMBER3] [varchar](4) NULL,
	[HP_NUMBER1] [varchar](4) NULL,
	[HP_NUMBER2] [varchar](4) NULL,
	[HP_NUMBER3] [varchar](4) NULL,
	[FAX_NUMBER1] [varchar](4) NULL,
	[FAX_NUMBER2] [varchar](4) NULL,
	[FAX_NUMBER3] [varchar](4) NULL,
	[GREETING] [varchar](200) NULL,
	[PASSPORT] [dbo].[PASSPORT] NULL,
	[PASS_EXPIRE_DATE] [dbo].[PASS_EXPIRE_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[BIRTH_DATE] [smalldatetime] NULL,
	[SALARY_CLASS] [varchar](3) NULL,
	[MATE_NUMBER] [varchar](4) NULL,
	[GROUP_TYPE] [int] NULL,
	[ACC_OUT_YN] [char](1) NULL,
	[CH_NUM] [int] NULL,
	[RECORD_YN] [char](1) NULL,
	[MY_AREA] [varchar](100) NULL,
	[SIGN_CODE] [varchar](1) NULL,
	[CTI_USE_YN] [char](1) NULL,
	[row_id] [uniqueidentifier] NULL,
	[sec_SOC_NUMBER2] [varbinary](16) NULL,
	[MATE_NUMBER2] [varchar](4) NULL,
	[MAIN_NUMBER1] [varchar](4) NULL,
	[MAIN_NUMBER2] [varchar](4) NULL,
	[MAIN_NUMBER3] [varchar](4) NULL,
	[IN_USE_YN] [varchar](1) NULL,
	[FALE_COUNT] [int] NULL,
	[BLOCK_YN] [char](1) NULL,
 CONSTRAINT [PK_EMP_MASTER] PRIMARY KEY CLUSTERED 
(
	[EMP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  CONSTRAINT [DEF_EMP_MASTER_GENDER]  DEFAULT ('F') FOR [GENDER]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  CONSTRAINT [DEF_EMP_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  DEFAULT ('Y') FOR [ACC_OUT_YN]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  CONSTRAINT [DEF_EMP_MASTER_RECORD_YN]  DEFAULT ('N') FOR [RECORD_YN]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  DEFAULT ('N') FOR [CTI_USE_YN]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  CONSTRAINT [EMP_MASTER_df_rowid]  DEFAULT (newid()) FOR [row_id]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  DEFAULT ('N') FOR [BLOCK_YN]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo]  WITH CHECK ADD  CONSTRAINT [R_4] FOREIGN KEY([TEAM_CODE])
REFERENCES [dbo].[EMP_TEAM] ([TEAM_CODE])
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] CHECK CONSTRAINT [R_4]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ENG_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ENG_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SOC_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'M : 남성, F : 여성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비밀번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PASSWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GROUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'근무타입 ( 1 : 재직, 2 : 휴직, 3 : 프리랜서, 4 : 실습생, 5 : 퇴사)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'WORK_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직책타입 ( 1 : 팀원, 2 : 팀장대행, 3 : 팀장, 4 : 부문장, 5 : 임원, 6 : 대표, 7 : 부회장, 8 : 회장 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'DUTY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직급타입 ( 1 : 사원, 2 : 계장, 3 : 대리, 4 : 과장, 5 : 차장, 6 : 부장, 7 : 상무보, 8 : 상무, 9 : 고문, 10 : 전무, 11 : 대표, 98 : 부회장, 99 : 회장 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'POS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입사타입 ( 1 : 신입, 2 : 경력 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'JOIN_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입사일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'JOIN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'퇴사일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'OUT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일비밀번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EMAIL_PASSWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메신저' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MESSENGER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내선번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내선번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내선번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'HP_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'HP_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'HP_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인사말' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GREETING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PASSPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권만료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PASS_EXPIRE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호봉' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SALARY_CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MATE_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부서타입 ( 1 : 영업, 2 : 비영업, 3 : 임원, 4 : 지점, 5 : 외부, 9 : 제외) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GROUP_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'외부접속가능여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ACC_OUT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'채널번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CH_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'녹취여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RECORD_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당지역명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MY_AREA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SIGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CTI사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CTI_USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'줄번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'row_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호_암호화필드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'sec_SOC_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MATE_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대표번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MAIN_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대표번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MAIN_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대표번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MAIN_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내선번호사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'IN_USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'로그인실패횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FALE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'차단여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'BLOCK_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo'
GO
