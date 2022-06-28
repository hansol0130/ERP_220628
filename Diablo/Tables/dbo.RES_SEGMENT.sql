USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_SEGMENT](
	[SEQ_NO] [int] NOT NULL,
	[DEP_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[ARR_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[DEP_CITY_CODE] [dbo].[CITY_CODE] NULL,
	[ARR_CITY_CODE] [dbo].[CITY_CODE] NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NULL,
	[SEAT_STATUS] [varchar](20) NULL,
	[FLIGHT] [varchar](20) NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[FLYING_TIME] [varchar](20) NULL,
	[GROUND_TIME] [varchar](20) NULL,
	[AIRLINE_PNR] [varchar](20) NULL,
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[BKG_CLASS] [varchar](2) NULL,
	[OP_AIRLINE_CODE] [dbo].[AIRLINE_CODE] NULL,
	[DIRECTION] [int] NULL,
	[FREE_BAG_INFO] [varchar](4) NULL,
 CONSTRAINT [XPK항공예약_세그정보] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC,
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_SEGMENT] ADD  DEFAULT ((0)) FOR [DIRECTION]
GO
ALTER TABLE [dbo].[RES_SEGMENT]  WITH CHECK ADD FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_AIR_DETAIL] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세그순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEAT_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공편' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비행시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLYING_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운항시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'GROUND_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사PNR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'AIRLINE_PNR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부킹클래스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'BKG_CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운항항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'OP_AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 출발, 1 : 귀국  -> ( 여정1 = 0, 여정2 = 1, 여정3 = 2, 여정4 = 3 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'DIRECTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'무료수화물규정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT', @level2type=N'COLUMN',@level2name=N'FREE_BAG_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공예약 세그정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SEGMENT'
GO
