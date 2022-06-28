USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_MASTER](
	[CNT_CODE] [int] IDENTITY(1,1) NOT NULL,
	[CNT_TYPE] [int] NOT NULL,
	[KOR_TITLE] [nvarchar](200) NOT NULL,
	[ORG_TITLE] [nvarchar](200) NULL,
	[ENG_TITLE] [nvarchar](200) NULL,
	[REGION_CODE] [varchar](3) NOT NULL,
	[NATION_CODE] [varchar](2) NOT NULL,
	[STATE_CODE] [varchar](4) NOT NULL,
	[CITY_CODE] [varchar](3) NOT NULL,
	[GPS_X] [varchar](30) NULL,
	[GPS_Y] [varchar](30) NULL,
	[SHOW_YN] [char](1) NULL,
	[SHOW_ORDER] [int] NULL,
	[SHORT_DESCRIPTION] [nvarchar](max) NULL,
	[DESCRIPTION] [nvarchar](max) NULL,
	[DISPLAY_TYPE] [int] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[COPYRIGHT_REMARK] [varchar](100) NULL,
	[COMPLETE_YN] [char](1) NULL,
 CONSTRAINT [PK_INF_MASTER] PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_MASTER] ADD  CONSTRAINT [DF_INF_MASTER_SHOW_ORDER]  DEFAULT ((5)) FOR [SHOW_ORDER]
GO
ALTER TABLE [dbo].[INF_MASTER] ADD  CONSTRAINT [DF_INF_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'None, 관광지, 호텔, 골프, 스키장, 옵션, 고정맵 = 9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'CNT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'KOR_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목-현지어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'ORG_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목-영어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'ENG_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'STATE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표 X' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'GPS_X'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표 Y' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'GPS_Y'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화면표시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화면표시순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요약설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'SHORT_DESCRIPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사진_간략정보 = 0, 상세정보만 = 1, 사진만 = 2, 간략정보만 = 3, 제목만 = 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'DISPLAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'저작권비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'COPYRIGHT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성완료여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER', @level2type=N'COLUMN',@level2name=N'COMPLETE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MASTER'
GO
