USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[MASTER_NAME] [nvarchar](100) NULL,
	[PKG_COMMENT] [nvarchar](100) NULL,
	[SIGN_CODE] [varchar](1) NULL,
	[ATT_CODE] [varchar](1) NULL,
	[TOUR_DAY] [int] NULL,
	[TOUR_JOURNEY] [nvarchar](400) NULL,
	[PKG_SUMMARY] [nvarchar](max) NULL,
	[PKG_INC_SPECIAL] [nvarchar](max) NULL,
	[PKG_REVIEW] [nvarchar](max) NULL,
	[PKG_CONTRACT] [nvarchar](max) NULL,
	[PKG_REMARK] [nvarchar](max) NULL,
	[RES_REMARK] [nvarchar](max) NULL,
	[PKG_SHOPPING_REMARK] [nvarchar](max) NULL,
	[HOTEL_REMARK] [nvarchar](max) NULL,
	[OPTION_REMARK] [nvarchar](max) NULL,
	[AIRLINE] [varchar](20) NULL,
	[SHOW_YN] [char](1) NULL,
	[LOW_PRICE] [int] NULL,
	[HIGH_PRICE] [int] NULL,
	[REGION_ORDER] [int] NULL,
	[THEME_ORDER] [int] NULL,
	[GROUP_ORDER] [int] NULL,
	[KEYWORD] [nvarchar](100) NULL,
	[MAIN_FILE_CODE] [int] NULL,
	[NEXT_DATE] [datetime] NULL,
	[LAST_DATE] [datetime] NULL,
	[EVENT_PRO_CODE] [dbo].[PRO_CODE] NULL,
	[EVENT_PRICE_SEQ] [int] NULL,
	[EVENT_NAME] [nvarchar](100) NULL,
	[EVENT_DEP_DATE] [datetime] NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[PKG_TOUR_REMARK] [varchar](8000) NULL,
	[PKG_PASSPORT_REMARK] [varchar](8000) NULL,
	[SECTION_YN] [char](1) NULL,
	[LOW_POINT_RATE] [decimal](4, 2) NULL,
	[HIGH_POINT_RATE] [decimal](4, 2) NULL,
	[BRANCH_CODE] [int] NULL,
	[BRAND_TYPE] [varchar](1) NULL,
	[AIRLINE_CODE] [char](2) NULL,
	[AIRPORT_CODE] [char](3) NULL,
	[SAFE_DATE] [datetime] NULL,
	[SAFE_STATUS] [int] NULL,
	[SAFE_REMARK] [varchar](100) NULL,
	[SAFE_REMARK_1] [nvarchar](600) NULL,
	[SAFE_REMARK_2] [nvarchar](600) NULL,
	[SAFE_REMARK_3] [nvarchar](600) NULL,
	[SWIM_INFO] [char](1) NULL,
	[TAG] [nvarchar](200) NULL,
	[LOW_PRICE_DATE] [datetime] NULL,
	[HOTEL_GRADE] [char](3) NULL,
	[PKG_TOOLTIP] [nvarchar](4000) NULL,
	[CLEAN_YN] [char](1) NULL,
	[SINGLE_YN] [char](1) NULL,
 CONSTRAINT [PK_PKG_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER] ADD  DEFAULT ((0)) FOR [BRANCH_CODE]
GO
ALTER TABLE [dbo].[PKG_MASTER] ADD  DEFAULT ('N') FOR [SWIM_INFO]
GO
ALTER TABLE [dbo].[PKG_MASTER] ADD  CONSTRAINT [DF_PKG_MASTER_HOTEL_GRADE]  DEFAULT ('000') FOR [HOTEL_GRADE]
GO
ALTER TABLE [dbo].[PKG_MASTER] ADD  DEFAULT ('N') FOR [CLEAN_YN]
GO
ALTER TABLE [dbo].[PKG_MASTER] ADD  DEFAULT ('N') FOR [SINGLE_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_COMMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대표지역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SIGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대표속성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'ATT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'TOUR_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행일정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'TOUR_JOURNEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품요약설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_SUMMARY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품추가사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_INC_SPECIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품리뷰' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_REVIEW'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'특별약관' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_CONTRACT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약시주의사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'RES_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑안내비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_SHOPPING_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'HOTEL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'OPTION_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부킹선호클래스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'AIRLINE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노출여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최저가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'LOW_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최고가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'HIGH_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역표시순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'REGION_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹표시순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'GROUP_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'키워드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'KEYWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대표이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'MAIN_FILE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'NEXT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'LAST_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'EVENT_PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'EVENT_PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'EVENT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'EVENT_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행준비물비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_TOUR_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권비자비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_PASSPORT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구분선여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SECTION_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최저포인트율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'LOW_POINT_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최고포인트율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'HIGH_POINT_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지점구분코드 - 0:본사 1:부산 99:기타 ( 본사 = 0, 부산 = 1, 대구 = 2, 대전 = 3, 광주 = 4, 기타 = 99 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'BRANCH_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'브랜드타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'BRAND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선호항공코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'안전정보기준일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SAFE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행안전상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SAFE_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'안전정보간략설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SAFE_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위험지역1단계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SAFE_REMARK_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위험지역2단계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SAFE_REMARK_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위험지역3단계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SAFE_REMARK_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'물놀이안전정보노출' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SWIM_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAG' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'TAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최저가 일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'LOW_PRICE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'HOTEL_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사툴팁' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'PKG_TOOLTIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행안전 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'CLEAN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품정보만 노출 여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER', @level2type=N'COLUMN',@level2name=N'SINGLE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER'
GO
