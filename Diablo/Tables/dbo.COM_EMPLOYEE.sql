USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_EMPLOYEE](
	[AGT_CODE] [varchar](10) NOT NULL,
	[EMP_SEQ] [int] NOT NULL,
	[TEAM_SEQ] [int] NULL,
	[EMP_ID] [varchar](20) NULL,
	[KOR_NAME] [varchar](20) NULL,
	[LAST_NAME] [varchar](20) NULL,
	[FIRST_NAME] [varchar](30) NULL,
	[BIRTH_DATE] [date] NULL,
	[GENDER] [char](1) NULL,
	[PASS_WORD] [varchar](100) NULL,
	[POS_SEQ] [int] NULL,
	[WORK_TYPE] [int] NULL,
	[JOIN_DATE] [datetime] NULL,
	[OUT_DATE] [datetime] NULL,
	[EMAIL] [varchar](50) NULL,
	[COM_NUMBER] [varchar](20) NULL,
	[HP_NUMBER] [varchar](20) NULL,
	[FAX_NUMBER] [varchar](20) NULL,
	[SEAT_REMARK] [varchar](100) NULL,
	[AIR_REMARK] [varchar](100) NULL,
	[HOTEL_REMARK] [varchar](100) NULL,
	[FAIL_COUNT] [int] NULL,
	[MANAGER_YN] [char](1) NULL,
	[MAIL_RECEIVE_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_SEQ] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_SEQ] [int] NULL,
	[VGL_DATE] [datetime] NULL,
	[VGL_CODE] [char](7) NULL,
	[DEL_YN] [char](1) NULL,
 CONSTRAINT [PK_COM_EMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[EMP_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[COM_EMPLOYEE] ADD  CONSTRAINT [COM_EMPLOYEE_DEL_YN_DEF]  DEFAULT (N'N') FOR [DEL_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'EMP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'TEAM_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'EMP_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성별' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비밀번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'PASS_WORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'POS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'근무타입(0 : 선택, 1 : 재직, 2 : 휴직, 3 : 퇴사)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'WORK_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입사일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'JOIN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'퇴사일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'OUT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'COM_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'HP_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선호좌석비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'SEAT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선호항공비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'AIR_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선호호텔비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'HOTEL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'로그인실패횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'FAIL_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인사담당자여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'MANAGER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메일수신유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'MAIL_RECEIVE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'NEW_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'EDT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VGL수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'VGL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VGL수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'VGL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사직원정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE'
GO
