USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_BUS_GGD_ROUTELINE](
	[ROUTE_ID] [char](9) NOT NULL,
	[LOCATION_SEQ] [int] NOT NULL,
	[LOCATION_TP] [int] NULL,
	[LOCATION_ID] [varchar](12) NULL,
	[SUB_LENGTH] [int] NULL,
	[SUM_LENGTH] [int] NULL,
	[X] [numeric](18, 10) NULL,
	[Y] [numeric](18, 10) NULL,
	[LINK_ID] [varchar](10) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ROUTE_ID] ASC,
	[LOCATION_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[API_BUS_GGD_ROUTELINE]  WITH CHECK ADD FOREIGN KEY([ROUTE_ID])
REFERENCES [dbo].[API_BUS_GGD_ROUTE] ([ROUTE_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'ROUTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위치순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'LOCATION_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위치타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'LOCATION_TP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위치ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'LOCATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구간길이' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'SUB_LENGTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구간길이의합' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'SUM_LENGTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'X좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'X'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'Y'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'링크ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'LINK_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTELINE'
GO
