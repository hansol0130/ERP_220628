USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_TRANSIT_SEGMENT](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[NO] [int] NOT NULL,
	[DEP_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[ARR_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[DEP_CITY_CODE] [dbo].[CITY_CODE] NULL,
	[ARR_CITY_CODE] [dbo].[CITY_CODE] NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NULL,
	[FLIGHT] [varchar](4) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[FLYING_TIME] [varchar](20) NULL,
	[GROUND_TIME] [varchar](20) NULL,
	[MILE] [varchar](20) NULL,
	[EQUIPMENT] [varchar](20) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [XPK항공예약_숨은세그정보] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC,
	[NO] ASC,
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_TRANSIT_SEGMENT]  WITH CHECK ADD  CONSTRAINT [FK__RES_TRANSIT_SEGM__1F83A428] FOREIGN KEY([SEQ_NO], [RES_CODE])
REFERENCES [dbo].[RES_SEGMENT] ([SEQ_NO], [RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_TRANSIT_SEGMENT] CHECK CONSTRAINT [FK__RES_TRANSIT_SEGM__1F83A428]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세그순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공편' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비행시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLYING_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연결시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'GROUND_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'MILE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공기종' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'EQUIPMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공예약 숨은세그정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_TRANSIT_SEGMENT'
GO
