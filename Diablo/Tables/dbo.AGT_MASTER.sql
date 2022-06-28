USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGT_MASTER](
	[AGT_CODE] [varchar](10) NOT NULL,
	[AGT_REGISTER] [char](10) NULL,
	[KOR_NAME] [varchar](50) NULL,
	[ENG_NAME] [varchar](30) NULL,
	[CEO_NAME] [varchar](50) NULL,
	[AGT_CONDITION] [varchar](50) NULL,
	[AGT_ITEM] [varchar](50) NULL,
	[AGT_TYPE_CODE] [char](2) NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[ADDRESS1] [varchar](100) NULL,
	[ADDRESS2] [varchar](100) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[FAX_TEL2] [varchar](5) NULL,
	[FAX_TEL1] [varchar](6) NULL,
	[FAX_TEL3] [varchar](4) NULL,
	[AGT_MGR_NAME] [varchar](20) NULL,
	[AGT_MGR_TEL1] [varchar](6) NULL,
	[AGT_MGR_TEL2] [varchar](5) NULL,
	[AGT_MGR_TEL3] [varchar](4) NULL,
	[AGT_MGR_EMAIL] [varchar](50) NULL,
	[ADMIN_REMARK] [varchar](1000) NULL,
	[SHOW_YN] [dbo].[USE_Y] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[URL] [varchar](50) NULL,
	[AGT_PART_CODE] [char](2) NULL,
	[USE_CODE] [varchar](10) NULL,
	[AGT_NAME] [varchar](50) NULL,
	[SYS_YN] [char](1) NULL,
	[AGT_GRADE] [varchar](1) NULL,
	[AREA_CODE] [varchar](25) NULL,
	[TAX_YN] [char](1) NULL,
	[COMM_RATE] [decimal](4, 2) NULL,
	[AGT_MGR_HAND1] [varchar](4) NULL,
	[AGT_MGR_HAND2] [varchar](4) NULL,
	[AGT_MGR_HAND3] [varchar](4) NULL,
	[PAY_LATER_YN] [char](1) NULL,
	[BTMS_YN] [char](1) NULL,
 CONSTRAINT [PK_AGT_MASTER] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AGT_MASTER] ADD  CONSTRAINT [DF_AGT_MASTER_SYS_YN]  DEFAULT ('N') FOR [SYS_YN]
GO
ALTER TABLE [dbo].[AGT_MASTER] ADD  DEFAULT ('N') FOR [TAX_YN]
GO
ALTER TABLE [dbo].[AGT_MASTER] ADD  DEFAULT ((0)) FOR [COMM_RATE]
GO
ALTER TABLE [dbo].[AGT_MASTER] ADD  DEFAULT ('N') FOR [PAY_LATER_YN]
GO
ALTER TABLE [dbo].[AGT_MASTER] ADD  DEFAULT ('N') FOR [BTMS_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사업자등록번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_REGISTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처명-한글' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처명-영문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'ENG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대표이사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'CEO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_CONDITION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업종' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_ITEM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처유형코드 ( 0 : 선택, 11 : 항공사, 12 : 랜드사, 15 : 항공권거래처, 16 : 일반거래처, 17 : 보험사, 18 : 기타거래처, 20 : 인센티브거래처, 21 : 간판_타여행사)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'FAX_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'FAX_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'FAX_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MGR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자전화번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MGR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자전화번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MGR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자전화번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MGR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MGR_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'ADMIN_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'홈페이지주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용처구분코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_PART_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실사용코드 ( 0 : 국내, 1 : 해외 , 2 : 경리, 3 : 공통)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'USE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사업자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SYS_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'SYS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'랜드사등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AREA_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세금계산서유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'TAX_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'COMM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처관리자 핸드폰번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MGR_HAND1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처관리자 핸드폰번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MGR_HAND2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처관리자 핸드폰번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MGR_HAND3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업체후불여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'PAY_LATER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BTMS유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER', @level2type=N'COLUMN',@level2name=N'BTMS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AGT_MASTER'
GO
