USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_BUS_GGD_ROUTE_STATION](
	[UPDOWN] [char](1) NULL,
	[STA_ORDER] [int] NOT NULL,
	[ROUTE_NM] [varchar](10) NULL,
	[STATION_NM] [nvarchar](40) NULL,
	[ROUTE_ID] [char](9) NOT NULL,
	[STATION_ID] [char](9) NOT NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ROUTE_ID] ASC,
	[STATION_ID] ASC,
	[STA_ORDER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[API_BUS_GGD_ROUTE_STATION]  WITH CHECK ADD FOREIGN KEY([ROUTE_ID])
REFERENCES [dbo].[API_BUS_GGD_ROUTE] ([ROUTE_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[API_BUS_GGD_ROUTE_STATION]  WITH CHECK ADD FOREIGN KEY([STATION_ID])
REFERENCES [dbo].[API_BUS_GGD_STATION] ([STATION_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상,하행구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION', @level2type=N'COLUMN',@level2name=N'UPDOWN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION', @level2type=N'COLUMN',@level2name=N'STA_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION', @level2type=N'COLUMN',@level2name=N'ROUTE_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION', @level2type=N'COLUMN',@level2name=N'STATION_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION', @level2type=N'COLUMN',@level2name=N'ROUTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정류소ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION', @level2type=N'COLUMN',@level2name=N'STATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경로_정류소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE_STATION'
GO
