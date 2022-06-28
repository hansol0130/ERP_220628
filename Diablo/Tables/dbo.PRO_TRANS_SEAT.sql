USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRO_TRANS_SEAT](
	[SEAT_CODE] [int] IDENTITY(1,1) NOT NULL,
	[DEP_TRANS_CODE] [char](2) NOT NULL,
	[DEP_TRANS_NUMBER] [char](4) NOT NULL,
	[DEP_DEP_DATE] [datetime] NULL,
	[DEP_ARR_DATE] [datetime] NULL,
	[DEP_DEP_TIME] [char](5) NULL,
	[DEP_ARR_TIME] [char](5) NULL,
	[DEP_SPEND_TIME] [char](5) NULL,
	[DEP_DEP_AIRPORT_CODE] [char](3) NULL,
	[DEP_ARR_AIRPORT_CODE] [char](3) NULL,
	[ARR_TRANS_CODE] [char](2) NOT NULL,
	[ARR_TRANS_NUMBER] [char](4) NOT NULL,
	[ARR_DEP_DATE] [datetime] NULL,
	[ARR_ARR_DATE] [datetime] NULL,
	[ARR_DEP_TIME] [char](5) NULL,
	[ARR_ARR_TIME] [char](5) NULL,
	[ARR_SPEND_TIME] [char](5) NULL,
	[ARR_DEP_AIRPORT_CODE] [char](3) NULL,
	[ARR_ARR_AIRPORT_CODE] [char](3) NULL,
	[ADT_PRICE] [int] NULL,
	[CHD_PRICE] [int] NULL,
	[INF_PRICE] [int] NULL,
	[SEAT_COUNT] [int] NULL,
	[MAX_SEAT_COUNT] [int] NULL,
	[SEAT_TYPE] [int] NULL,
	[TRANS_TYPE] [int] NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[FARE_SEAT_TYPE] [int] NULL,
	[SYS_CHK_YN] [char](1) NULL,
	[SYS_CHK_REMARK] [varchar](1000) NULL,
	[SYS_CHK_DATE] [datetime] NULL,
 CONSTRAINT [PK_PRO_TRANS_SEAT] PRIMARY KEY CLUSTERED 
(
	[SEAT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'SEAT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국운항사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_TRANS_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편출발시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편도착시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_ARR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편소요시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_SPEND_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국편도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'DEP_ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국운항사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_TRANS_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편출발시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편도착시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_ARR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편소요시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_SPEND_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국편도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ARR_ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'ADT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'CHD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'INF_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보유좌석수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'SEAT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'허용좌석수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'MAX_SEAT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전체 : 0 , 블럭 : 1, 시리즈 : 2, 전세기 : 3, 조인 : 4, 인디비 : 5, 기타 : 6, 결합 : 7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'SEAT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: 항공, 2: 선박' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'TRANS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공요금타입 ( 전체 = 0, 일반석 = 1, 프리미엄일반석 =2 , 비지니스 =3, 일등석 =4 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'FARE_SEAT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시스템체크여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'SYS_CHK_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시스템체크비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'SYS_CHK_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시스템체크일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT', @level2type=N'COLUMN',@level2name=N'SYS_CHK_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT'
GO
