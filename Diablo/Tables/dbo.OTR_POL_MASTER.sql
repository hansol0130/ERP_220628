USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OTR_POL_MASTER](
	[OTR_POL_MASTER_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[OTR_SEQ] [int] NOT NULL,
	[TARGET] [char](1) NOT NULL,
	[POL_TYPE] [char](1) NOT NULL,
	[SUBJECT] [varchar](400) NOT NULL,
	[POL_DESC] [text] NULL,
	[OTR_DATE1] [varchar](10) NULL,
	[OTR_DATE2] [varchar](10) NULL,
	[OTR_CITY] [varchar](60) NULL,
	[AGT_CODE] [varchar](10) NULL,
	[GUIDE_NAME] [varchar](50) NULL,
	[MEM_CODE] [varchar](7) NULL,
	[HOTEL_NAME] [varchar](60) NULL,
	[MEAL_TYPE] [varchar](1) NULL,
	[RESTAURANT_NAME] [varchar](60) NULL,
	[CLIENT_NAME] [varchar](50) NULL,
	[CLIENT_TEL] [varchar](16) NULL,
	[CLIENT_CALL_YN] [varchar](1) NULL,
	[APP_LIST] [nvarchar](500) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NOT NULL,
	[AGT_NAME] [varchar](50) NULL,
 CONSTRAINT [PK_OTR_POL_MASTER] PRIMARY KEY CLUSTERED 
(
	[OTR_POL_MASTER_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[OTR_POL_MASTER] ADD  CONSTRAINT [DF_OTR_POL_MASTER_TARGET]  DEFAULT ('3') FOR [TARGET]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서설문번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'OTR_POL_MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'OTR_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 비회원, 2 : 회원, 3 : 내부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'TARGET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 전체평가, 2 : 가이드평가, 3 : 호텔평가, 4 : 식사평가, 5 : 고객평가, 6 : 이벤트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'POL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설문설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'POL_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행일1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'OTR_DATE1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행일2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'OTR_DATE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행도시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'OTR_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가이드명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'GUIDE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'MEM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'HOTEL_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 조식, 1 : 중식, 2 : 석식' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'MEAL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'식당명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'RESTAURANT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'CLIENT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'CLIENT_TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y : 성공, N : 거부, F : 실패' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'CLIENT_CALL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참조자리스트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'APP_LIST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'랜드사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서 설문 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_POL_MASTER'
GO
