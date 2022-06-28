USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_BUS_SEL_ROUTE_PATH](
	[SEQ] [int] NOT NULL,
	[GPS_X] [numeric](18, 10) NULL,
	[GPS_Y] [numeric](18, 10) NULL,
	[ROUTE_ID] [char](9) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ROUTE_ID] ASC,
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[API_BUS_SEL_ROUTE_PATH]  WITH CHECK ADD FOREIGN KEY([ROUTE_ID])
REFERENCES [dbo].[API_BUS_SEL_ROUTE] ([ROUTE_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE_PATH', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'X좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE_PATH', @level2type=N'COLUMN',@level2name=N'GPS_X'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE_PATH', @level2type=N'COLUMN',@level2name=N'GPS_Y'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE_PATH', @level2type=N'COLUMN',@level2name=N'ROUTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE_PATH', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE_PATH', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' 노선경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE_PATH'
GO
