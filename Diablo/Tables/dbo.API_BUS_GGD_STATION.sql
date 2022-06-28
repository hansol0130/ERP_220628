USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_BUS_GGD_STATION](
	[STATION_ID] [char](9) NOT NULL,
	[STATION_NAME] [nvarchar](40) NULL,
	[MOBILE_NO] [varchar](6) NULL,
	[CENTER_ID] [char](8) NULL,
	[CENTER_YN] [char](1) NULL,
	[GPS_X] [numeric](18, 10) NULL,
	[GPS_Y] [numeric](18, 10) NULL,
	[REGION_NAME] [nvarchar](10) NULL,
	[DISTRICT_CD] [char](1) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[STATION_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'STATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'STATION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모바일번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'MOBILE_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지자체ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'CENTER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'중앙차로여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'CENTER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'X좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'GPS_X'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'GPS_Y'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'REGION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'DISTRICT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_STATION'
GO
