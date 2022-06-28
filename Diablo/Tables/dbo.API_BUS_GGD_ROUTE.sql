USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_BUS_GGD_ROUTE](
	[ROUTE_ID] [char](9) NOT NULL,
	[ROUTE_NM] [nvarchar](10) NULL,
	[ROUTE_TP] [int] NULL,
	[ST_STA_ID] [char](9) NULL,
	[ST_STA_NM] [nvarchar](40) NULL,
	[ST_STA_NO] [char](9) NULL,
	[ED_STA_ID] [char](9) NULL,
	[ED_STA_NM] [nvarchar](40) NULL,
	[ED_STA_NO] [char](9) NULL,
	[UP_FIRST_TIME] [char](5) NULL,
	[UP_LAST_TIME] [char](5) NULL,
	[DOWM_FIRST_TIME] [char](5) NULL,
	[DOWN_LAST_TIME] [char](5) NULL,
	[PEEK_ALLOC] [int] NULL,
	[NPEEK_ALLOC] [int] NULL,
	[COMPANY_ID] [char](7) NULL,
	[COMPANY_NM] [nvarchar](20) NULL,
	[TEL_NO] [varchar](20) NULL,
	[REGION_NAME] [nvarchar](50) NULL,
	[DISTRICT_CD] [char](1) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ROUTE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ROUTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ROUTE_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선형태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ROUTE_TP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기점정류장ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ST_STA_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기점정류장명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ST_STA_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기점정류장번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ST_STA_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종점정류장ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ED_STA_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종점정류장명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ED_STA_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종점정류장번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'ED_STA_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상행첫차시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'UP_FIRST_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상행막차시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'UP_LAST_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'하행첫차시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'DOWM_FIRST_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'하행막차시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'DOWN_LAST_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출퇴근시배차간격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'PEEK_ALLOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평상시배차간격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'NPEEK_ALLOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운수사ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'COMPANY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운수사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'COMPANY_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운수사연락처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'TEL_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'REGION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'DISTRICT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_GGD_ROUTE'
GO
