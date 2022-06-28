USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[PRO_NAME] [dbo].[PRO_NAME] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[TRANSFER_TYPE] [int] NULL,
	[SEAT_CODE] [int] NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[TOUR_NIGHT] [int] NULL,
	[TOUR_DAY] [int] NULL,
	[TOUR_JOURNEY] [nvarchar](400) NULL,
	[SEAT_STATUS] [char](2) NULL,
	[FAKE_COUNT] [int] NULL,
	[MAX_COUNT] [int] NULL,
	[MIN_COUNT] [int] NULL,
	[LAST_PAY_DATE] [datetime] NULL,
	[SENDING_YN] [char](1) NULL,
	[SENDING_DATE] [datetime] NULL,
	[TC_YN] [char](1) NULL,
	[TC_CODE] [varchar](20) NULL,
	[TC_NAME] [varchar](20) NULL,
	[RES_ADD_YN] [char](1) NULL,
	[RES_EDT_YN] [char](1) NULL,
	[DEP_CFM_YN] [char](1) NULL,
	[CONFIRM_YN] [char](1) NULL,
	[INS_CODE] [varchar](10) NULL,
	[INS_YN] [char](1) NULL,
	[VISA_YN] [char](1) NULL,
	[PASS_INFO] [varchar](200) NULL,
	[FIRST_MEET] [varchar](200) NULL,
	[SALE_TYPE] [int] NULL,
	[PRICE_TYPE] [int] NULL,
	[AIR_GDS] [int] NULL,
	[HOTEL_GDS] [int] NULL,
	[AIRLINE] [varchar](20) NULL,
	[PKG_SUMMARY] [varchar](max) NULL,
	[PKG_INC_SPECIAL] [varchar](max) NULL,
	[PKG_REVIEW] [varchar](max) NULL,
	[PKG_CONTRACT] [nvarchar](max) NULL,
	[PKG_REMARK] [nvarchar](max) NULL,
	[RES_REMARK] [nvarchar](max) NULL,
	[PKG_SHOPPING_REMARK] [nvarchar](max) NULL,
	[HOTEL_REMARK] [nvarchar](max) NULL,
	[OPTION_REMARK] [nvarchar](max) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [datetime] NULL,
	[PKG_TOUR_REMARK] [varchar](8000) NULL,
	[PKG_PASSPORT_REMARK] [varchar](8000) NULL,
	[INS_DAY] [int] NULL,
	[PKG_INSIDE_REMARK] [nvarchar](1000) NULL,
	[MONITORING_YN] [char](1) NULL,
	[MONITORING_WRITE_YN] [char](1) NULL,
	[PRO_TYPE] [int] NULL,
	[MEET_COUNTER] [int] NULL,
	[TC_ASSIGN_YN] [char](1) NULL,
	[TC_ASSIGN_DATE] [datetime] NULL,
	[TC_LAND_YN] [char](1) NULL,
	[GUIDE_YN] [char](1) NULL,
	[AIR_CFM_YN] [char](1) NULL,
	[ROOM_CFM_YN] [char](1) NULL,
	[SCHEDULE_CFM_YN] [char](1) NULL,
	[PRICE_CFM_YN] [char](1) NULL,
	[UNITE_YN] [char](1) NULL,
 CONSTRAINT [PK_PKG_DETAIL] PRIMARY KEY NONCLUSTERED 
(
	[PRO_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  CONSTRAINT [DF_PKG_DETAIL_PRO_TYPE]  DEFAULT ((1)) FOR [PRO_TYPE]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  CONSTRAINT [DEF_PKG_DETAIL_MEET_COUNTER]  DEFAULT ((0)) FOR [MEET_COUNTER]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  DEFAULT ('N') FOR [TC_ASSIGN_YN]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  DEFAULT ('N') FOR [TC_LAND_YN]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  CONSTRAINT [DEF_PKG_DETAIL_GUIDE_YN]  DEFAULT ('N') FOR [GUIDE_YN]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  CONSTRAINT [DEF_PKG_DETAIL_AIR_CFM_YN]  DEFAULT ('N') FOR [AIR_CFM_YN]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  CONSTRAINT [DEF_PKG_DETAIL_ROOM_CFM_YN]  DEFAULT ('N') FOR [ROOM_CFM_YN]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  CONSTRAINT [DEF_PKG_DETAIL_SCHEDULE_CFM_YN]  DEFAULT ('N') FOR [SCHEDULE_CFM_YN]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  CONSTRAINT [DEF_PKG_DETAIL_PRICE_CFM_YN]  DEFAULT ('N') FOR [PRICE_CFM_YN]
GO
ALTER TABLE [dbo].[PKG_DETAIL] ADD  CONSTRAINT [DEF_PKG_DETAIL_UNITE_YN]  DEFAULT ('N') FOR [UNITE_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교통편타입 ( 전체 = 0 , 항공 = 1 , 선박 = 2, 기타 = 3 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TRANSFER_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'SEAT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관광박수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TOUR_NIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관광일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TOUR_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행일정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TOUR_JOURNEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'SEAT_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가짜예약자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'FAKE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대인원수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'MAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최소출발인원수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'MIN_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금마감일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'LAST_PAY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'센딩유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'SENDING_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'센딩일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'SENDING_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약추가가능여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_ADD_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약수정가능여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_EDT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발확정여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품확정여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'CONFIRM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'INS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험확정여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'INS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비자필수여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'VISA_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PASS_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첫만남' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'FIRST_MEET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 일반, 2 : 긴급, 3 : 집중, 4 : 유도 ( None = 0 , 일반모객 = 1, 긴급모객 = 2, 집중모객 = 3, 유도모객 = 4 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'SALE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ex) 1 - 일반 2 - 특가  ( None = 0 , 일반 = 1 , 특가 =2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PRICE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공GDS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'AIR_GDS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔GDS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'HOTEL_GDS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부킹선호클래스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'AIRLINE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품요약설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_SUMMARY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품특전사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_INC_SPECIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품리뷰' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_REVIEW'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'특별약관' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_CONTRACT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일반비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약시주의사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑안내비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_SHOPPING_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'HOTEL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'OPTION_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화면표시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행준비물비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_TOUR_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권비자비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_PASSPORT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'INS_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내부관리비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PKG_INSIDE_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모니터링여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'MONITORING_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모니터링작성여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'MONITORING_WRITE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사타입 (  패키지 = 1, 항공 = 2, 호텔 = 3, 자유여행 = 4, 옵션 = 5, 전체 = 9 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'미팅카운터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'MEET_COUNTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자배정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TC_ASSIGN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자배정시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TC_ASSIGN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'랜드사배정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'TC_LAND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가이드유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'GUIDE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공확정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'AIR_CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박확정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'ROOM_CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정확정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'SCHEDULE_CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격확정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'PRICE_CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연합유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'UNITE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL'
GO
