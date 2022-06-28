USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_MASTER](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[CNT_CODE] [int] NULL,
	[MASTER_NAME] [nvarchar](200) NULL,
	[REGION_CODE] [dbo].[REGION_CODE] NULL,
	[NATION_CODE] [dbo].[NATION_CODE] NULL,
	[STATE_CODE] [dbo].[STATE_CODE] NULL,
	[CITY_CODE] [dbo].[CITY_CODE] NULL,
	[HTL_STAY_CODE] [varchar](2) NULL,
	[HTL_GRADE] [int] NULL,
	[LOCATION_TYPE] [int] NULL,
	[RES_ONLINE_YN] [char](1) NULL,
	[RES_REPLY_TIME_TYPE] [int] NULL,
	[CXL_ONLINE_YN] [char](1) NULL,
	[CXL_REPLY_TIME_TYPE] [int] NULL,
	[RECOME_YN] [char](1) NULL,
	[RECOME_REMARK] [varchar](500) NULL,
	[CONTRACT] [varchar](4000) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[RECOME_URL] [varchar](100) NULL,
	[POINT_RATE] [decimal](4, 2) NULL,
	[RECOMMAND_ORDER] [int] NULL,
	[LOCATION_CODE] [varchar](100) NULL,
 CONSTRAINT [PK_HTL_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HTL_MASTER] ADD  CONSTRAINT [DF_HTL_MASTER_RECOMMAND_ORDER]  DEFAULT ((5)) FOR [RECOMMAND_ORDER]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'STATE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔종류 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'HTL_STAY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔등급 ( 0 : 전체, 10 : 별1, 15 : 별1_5, 20 : 별2, 25 : 별2_5, 30 : 별3, 35 : 별3_5, 40 : 별4, 45 : 별4_5, 50 : 별5, 60 : 별6, 70 : 별7 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'HTL_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주변정보 ( 0 : 알수없음, 1 : 시내중심, 2 : 공항중심, 3 : 역근처, 4 : 항구근처, 5 : 해변근처, 6 : 변두리, 7 : 산근처, 8 : 외곽도시, 9 : 시내근처 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'LOCATION_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약실시간유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'RES_ONLINE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : None, 1 : 두시간, 2 : 여섯시간, 3 : 열두시간, 4 : 스물네시간 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'RES_REPLY_TIME_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소실시간유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'CXL_ONLINE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소회신시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'CXL_REPLY_TIME_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추천유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'RECOME_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추천사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'RECOME_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'약관' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'CONTRACT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'활성유무 ( 0 : None, 1 : 활성, 2 : 비활성 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'RECOME_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'POINT_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추천순위' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'RECOMMAND_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위치코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER', @level2type=N'COLUMN',@level2name=N'LOCATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_MASTER'
GO
