USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_BUS_SEL_STATION](
	[ROUTE_ID] [char](9) NOT NULL,
	[SEQ] [int] NOT NULL,
	[SECTION_ID] [varchar](9) NULL,
	[STATION_ID] [char](9) NULL,
	[STATION_NAME] [nvarchar](40) NULL,
	[GPS_X] [numeric](18, 10) NULL,
	[GPS_Y] [numeric](18, 10) NULL,
	[DIRECTION] [nvarchar](40) NULL,
	[START_TIME] [char](5) NULL,
	[LAST_TIME] [char](5) NULL,
	[FULL_SECT_DIST] [numeric](18, 10) NULL,
	[STATION_NO] [varchar](10) NULL,
	[TRAN_STN_ID] [varchar](9) NULL,
	[SECT_SPD] [int] NULL,
	[TRAN_YN] [char](1) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ROUTE_ID] ASC,
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[API_BUS_SEL_STATION]  WITH CHECK ADD FOREIGN KEY([ROUTE_ID])
REFERENCES [dbo].[API_BUS_SEL_ROUTE] ([ROUTE_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'ROUTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구간ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'SECTION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'STATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'STATION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'X좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'GPS_X'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'GPS_Y'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'진행방향' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'DIRECTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첫차시간_HHMM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'START_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'막차시간_HHMM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'LAST_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소간거리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'FULL_SECT_DIST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'STATION_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회차지정류소ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'TRAN_STN_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구간속도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'SECT_SPD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회차지여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'TRAN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' 노선_정류소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_STATION'
GO
