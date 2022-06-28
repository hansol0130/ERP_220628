USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_BUS_SEL_ROUTE](
	[ROUTE_ID] [char](9) NOT NULL,
	[ROUTE_NAME] [nvarchar](15) NULL,
	[ROUTE_LENGTH] [varchar](15) NULL,
	[ROUTE_TYPE] [int] NULL,
	[START_NAME] [nvarchar](40) NULL,
	[END_NAME] [nvarchar](40) NULL,
	[TERM] [int] NULL,
	[FIRST_BUS_TIME] [char](14) NULL,
	[LAST_BUS_TIME] [char](14) NULL,
	[FIRST_LOW_TIME] [char](14) NULL,
	[LAST_LOW_TIME] [char](14) NULL,
	[COP_NAME] [nvarchar](40) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[ROUTE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'ROUTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'ROUTE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선_길이' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'ROUTE_LENGTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선_유형' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'ROUTE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기점' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'START_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종점' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'END_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'배차간격_분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'TERM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'금일첫차시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'FIRST_BUS_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'금일막차시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'LAST_BUS_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'금일저상첫차시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'FIRST_LOW_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'금일저상막차시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'LAST_LOW_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운수사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'COP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노선' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_BUS_SEL_ROUTE'
GO
