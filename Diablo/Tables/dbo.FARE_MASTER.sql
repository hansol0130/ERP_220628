USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FARE_MASTER](
	[FARE_CODE] [int] IDENTITY(1,1) NOT NULL,
	[FARE_SOURCE] [varchar](100) NULL,
	[IATA_NO] [int] NULL,
	[AIRLINE_CODE] [char](2) NULL,
	[REGION_CODE] [char](3) NULL,
	[DEP_CITY_CODE] [char](3) NULL,
	[DEP_AIRPORT_CODE] [char](3) NULL,
	[ARR_CITY_CODE] [char](3) NULL,
	[ARR_AIRPORT_CODE] [char](3) NULL,
	[ARR_CITY_CODE2] [char](3) NULL,
	[ARR_CITY_ZONE_YN] [char](1) NULL,
	[FARE_BASIS] [varchar](20) NULL,
	[IATA_BASIS] [varchar](20) NULL,
	[IATA_GRADE] [char](2) NULL,
	[CURRENCY] [char](3) NULL,
	[ADT_IND] [char](2) NULL,
	[ADT_PRICE] [int] NULL,
	[ADT_OPT_PRICE] [int] NULL,
	[CHD_IND] [char](2) NULL,
	[CHD_PRICE] [int] NULL,
	[CHD_OPT_PRICE] [int] NULL,
	[INF_IND] [char](2) NULL,
	[INF_PRICE] [int] NULL,
	[INF_OPT_PRICE] [int] NULL,
	[COMPARTMENT] [varchar](20) NULL,
	[IDT_CODE] [varchar](10) NOT NULL,
	[MIN_STAY] [varchar](3) NULL,
	[MAX_STAY] [varchar](3) NULL,
	[BEFORE_DAY] [varchar](3) NULL,
	[AFTER_DAY] [varchar](3) NULL,
	[DEP_WEEKDAY] [char](7) NULL,
	[ARR_WEEKDAY] [char](7) NULL,
	[TIME_LIMIT] [char](8) NULL,
	[RTG_TYPE] [int] NULL,
	[RTG_EXTEND_YN] [char](1) NULL,
	[FULL_STOPOVER] [varchar](50) NULL,
	[OB_STOPOVER] [varchar](50) NULL,
	[IB_STOPOVER] [varchar](50) NULL,
	[SP_STOPOVER] [varchar](50) NULL,
	[ADD_CODE] [varchar](20) NULL,
	[ADD_SECTOR] [varchar](20) NULL,
	[OPEN_YN] [char](1) NULL,
	[BKG_CLASS] [char](1) NULL,
	[USE_CREDIT_CARD] [varchar](20) NULL,
	[SALE_START_DATE] [datetime] NULL,
	[SALE_END_DATE] [datetime] NULL,
	[VIA_COUNT] [int] NULL,
	[ETICKET_YN] [char](1) NULL,
	[SEASON_CODE] [char](2) NULL,
	[SEASON_EXT] [int] NULL,
	[MIN_STAY_WAVE] [char](2) NULL,
	[WAVE_FLT] [varchar](100) NULL,
	[SURCHARGE_IND] [char](3) NULL,
	[SHOW_YN] [char](1) NULL,
	[FIXED_YN] [char](1) NULL,
	[FARE_GRADE] [varchar](18) NULL,
	[AUTH_CODE] [varchar](20) NULL,
	[TOUR_CODE] [varchar](20) NULL,
	[SURFACE_YN] [char](1) NULL,
	[AUTO_ISSUE_YN] [char](1) NULL,
	[FARE_SALE_YN] [char](1) NULL,
	[DEP_CHANGE_YN] [char](1) NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
 CONSTRAINT [PK_FARE_MASTER] PRIMARY KEY CLUSTERED 
(
	[FARE_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FARE_MASTER] ADD  CONSTRAINT [DF_FARE_MASTER_ARR_CITY_ZONE_YN]  DEFAULT ('N') FOR [ARR_CITY_ZONE_YN]
GO
ALTER TABLE [dbo].[FARE_MASTER] ADD  CONSTRAINT [DEF_CURRENCY]  DEFAULT ('KRW') FOR [CURRENCY]
GO
ALTER TABLE [dbo].[FARE_MASTER] ADD  CONSTRAINT [DEF_Y4]  DEFAULT ('Y') FOR [SHOW_YN]
GO
ALTER TABLE [dbo].[FARE_MASTER] ADD  CONSTRAINT [DF_FARE_MASTER_FIXED_YN]  DEFAULT ('N') FOR [FIXED_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'FARE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_CITY_CODE2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ????????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_CITY_ZONE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAREBASIS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'FARE_BASIS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IATA BASIS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'IATA_BASIS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IATA_GRADE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'IATA_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'CURRENCY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ADT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ADT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ADT_OPT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'CHD_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'CHD_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'CHD_OPT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'INF_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'INF_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'INF_OPT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'COMPARTMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'MIN_STAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'MAX_STAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'BEFORE_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'AFTER_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_WEEKDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_WEEKDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'TIME_LIMIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : ??????, 1 : ??????, 2 : ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'RTG_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'RTG_EXTEND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'FULL_STOPOVER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OUTBOUND ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'OB_STOPOVER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'INBOUND ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'IB_STOPOVER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SPECIAL ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'SP_STOPOVER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ADD-ON ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ADD_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ADD-ON ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ADD_SECTOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'OPEN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'BKG_CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'USE_CREDIT_CARD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'SALE_START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'SALE_END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'VIA_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ETICKET ????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'ETICKET_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'SEASON_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'SEASON_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????? ???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'MIN_STAY_WAVE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'WAVE_FLT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'SURCHARGE_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'FIXED_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'FARE_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'AUTH_CODE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'AUTH_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TOUR_CODE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'TOUR_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????? ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'SURFACE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'AUTO_ISSUE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'FARE_SALE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_CHANGE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_MASTER'
GO
