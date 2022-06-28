USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGT_MEMBER](
	[MEM_CODE] [char](7) NOT NULL,
	[AGT_CODE] [varchar](10) NULL,
	[MEM_TYPE] [int] NULL,
	[WORK_TYPE] [int] NULL,
	[KOR_NAME] [varchar](20) NULL,
	[ENG_LAST_NAME] [varchar](20) NULL,
	[ENG_FIRST_NAME] [varchar](20) NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[POS_NAME] [varchar](20) NULL,
	[PASSWORD] [varchar](20) NULL,
	[TEL_NUMBER1] [varchar](4) NULL,
	[TEL_NUMBER2] [varchar](4) NULL,
	[TEL_NUMBER3] [varchar](4) NULL,
	[HP_NUMBER1] [varchar](4) NULL,
	[HP_NUMBER2] [varchar](4) NULL,
	[HP_NUMBER3] [varchar](4) NULL,
	[EMAIL] [varchar](50) NULL,
	[ZIP_CODE] [varchar](7) NULL,
	[ADDRESS1] [varchar](50) NULL,
	[ADDRESS2] [varchar](80) NULL,
	[BLOCK_COUNT] [int] NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[AGT_GRADE] [varchar](1) NULL,
	[WORK_TYPE_START] [date] NULL,
	[WORK_TYPE_END] [date] NULL,
	[GENDER] [char](1) NULL,
	[BIRTH_DATE] [varchar](10) NULL,
 CONSTRAINT [PK_AGT_MEMBER] PRIMARY KEY CLUSTERED 
(
	[MEM_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AGT_MEMBER] ADD  CONSTRAINT [DF_AGT_MEMBER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[AGT_MEMBER] ADD  CONSTRAINT [DEF_AGT_MEMBER_GENDER]  DEFAULT ('M') FOR [GENDER]
GO
ALTER TABLE [dbo].[AGT_MEMBER]  WITH CHECK ADD  CONSTRAINT [FK_AGT_MASTER_AGT_MEMBER] FOREIGN KEY([AGT_CODE])
REFERENCES [dbo].[AGT_MASTER] ([AGT_CODE])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AGT_MEMBER] CHECK CONSTRAINT [FK_AGT_MASTER_AGT_MEMBER]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'MEM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 직원, 1 : 가이드, 9 : 관리자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'MEM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 전체, 1 : 재직, 2 : 휴직 , 5 : 퇴사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'WORK_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'ENG_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'ENG_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'POS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비밀번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'PASSWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'휴대전화번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'HP_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'휴대전화번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'HP_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'휴대전화번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'HP_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'차단횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'BLOCK_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : A, 1 : B, 2 : C , 3 : D , 4 : E' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'AGT_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업무상태시작' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'WORK_TYPE_START'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업무상태종료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'WORK_TYPE_END'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성별' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처직원정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MEMBER'
GO
