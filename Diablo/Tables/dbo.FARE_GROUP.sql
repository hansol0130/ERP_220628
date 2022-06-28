USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FARE_GROUP](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[PRO_TYPE] [char](1) NULL,
	[AIRLINE_CODE] [char](2) NULL,
	[DEP_DEP_DATE] [datetime] NULL,
	[DEP_ARR_DATE] [datetime] NULL,
	[ARR_DEP_DATE] [datetime] NULL,
	[ARR_ARR_DATE] [datetime] NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[NOR_PRICE] [int] NULL,
	[MIN_COUNT] [int] NULL,
	[MAX_COUNT] [int] NULL,
	[MAX_STAY] [varchar](3) NULL,
	[SHOW_YN] [dbo].[USE_Y] NULL,
	[MANAGER_CODE] [dbo].[NEW_CODE] NOT NULL,
	[TOUR_DAY] [int] NULL,
	[SEAT_COUNT] [int] NULL,
	[TL_DATE] [datetime] NULL,
	[ADT_TAX_PRICE] [int] NULL,
	[CHD_TAX_PRICE] [int] NULL,
	[INF_TAX_PRICE] [int] NULL,
	[ADT_PRICE] [int] NULL,
	[CHD_PRICE] [int] NULL,
	[INF_PRICE] [int] NULL,
	[ADMIN_REMARK] [nvarchar](max) NULL,
	[PNR_CODE] [varchar](20) NULL,
	[CRS] [char](1) NULL,
	[BKG_CLASS] [char](1) NULL,
	[DEP_FLT_NUMBER] [varchar](20) NULL,
	[ARR_FLT_NUMBER] [varchar](20) NULL,
	[RULE_CODE] [varchar](20) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [char](7) NULL,
	[PNR_REMARK] [nvarchar](max) NULL,
	[DEP_CFM_YN] [dbo].[USE_N] NULL,
	[RES_ADD_YN] [dbo].[USE_Y] NULL,
	[LAST_PAY_DATE] [datetime] NULL,
	[REAL_YN] [dbo].[USE_N] NULL,
	[REPLY_TIME] [char](1) NULL,
	[PRO_NAME] [varchar](100) NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[SEAT_CODE] [dbo].[SEAT_CODE] NOT NULL,
	[DEP_DEP_TIME] [char](5) NULL,
	[DEP_ARR_TIME] [char](5) NULL,
	[ARR_DEP_TIME] [char](5) NULL,
	[ARR_ARR_TIME] [char](5) NULL,
	[DEP_SPEND_TIME] [char](5) NULL,
	[ARR_SPEND_TIME] [char](5) NULL,
	[DEP_DEP_AIRPORT_CODE] [char](3) NULL,
	[DEP_ARR_AIRPORT_CODE] [char](3) NULL,
	[ARR_DEP_AIRPORT_CODE] [char](3) NULL,
	[ARR_ARR_AIRPORT_CODE] [char](3) NULL,
	[FAKE_COUNT] [int] NULL,
 CONSTRAINT [PK_FARE_GROUP] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 실시간항공, 1 : 공동구매, 2 : 할인항공, 3 : 땡처리항공, 4 : 프로모션 상품, S : 깜짝특가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ARR_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ARR_ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매시작기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매종료기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정상가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'NOR_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최소출발인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'MIN_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대출발인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'MAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대체류일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'MAX_STAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'화면표시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'MANAGER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'TOUR_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보유좌석수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'SEAT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권시한' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'TL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ADT_TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'CHD_TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아TAX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'INF_TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ADT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'CHD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'INF_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자 비고사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ADMIN_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'PNR_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CRS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'CRS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부킹클래스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'BKG_CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_FLT_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회양편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ARR_FLT_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용규정코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'RULE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR비고사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'PNR_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발확정여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약허용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'RES_ADD_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금마감일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'LAST_PAY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실시간유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'REAL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 실시간, 1 : 6시간, 2 : 12시간, 3 : 24시간, 4 : 48시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'REPLY_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석관리코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'SEAT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편출발시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편도착시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_ARR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편소요시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ARR_DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편출발시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ARR_ARR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편도착시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_SPEND_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편소요시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ARR_SPEND_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'DEP_ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ARR_DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'ARR_ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가짜예약자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP', @level2type=N'COLUMN',@level2name=N'FAKE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공동구매' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP'
GO
