USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_CITY](
	[CITY_CODE] [char](3) NOT NULL,
	[KOR_NAME] [nvarchar](100) NULL,
	[ENG_NAME] [varchar](100) NULL,
	[NATION_CODE] [char](2) NULL,
	[STATE_CODE] [varchar](4) NULL,
	[GMT_TIME] [varchar](5) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[MAJOR_YN] [char](1) NULL,
	[ORDER_SEQ] [int] NULL,
	[GPS_X] [varchar](30) NULL,
	[GPS_Y] [varchar](30) NULL,
	[IS_USE_HTL] [char](1) NULL,
	[IS_USE_AIR] [char](1) NULL,
 CONSTRAINT [PK_PUB_CITY] PRIMARY KEY CLUSTERED 
(
	[CITY_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_CITY] ADD  CONSTRAINT [DF_PUB_CITY_IS_USE_HTL]  DEFAULT ((0)) FOR [IS_USE_HTL]
GO
ALTER TABLE [dbo].[PUB_CITY] ADD  CONSTRAINT [DF_PUB_CITY_IS_USE_AIR]  DEFAULT ((0)) FOR [IS_USE_AIR]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글도시명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문도시명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'ENG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'STATE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기준시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'GMT_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주요도시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'MAJOR_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'ORDER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'GPS_X'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'위도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'GPS_Y'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔노출여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'IS_USE_HTL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공노출여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY', @level2type=N'COLUMN',@level2name=N'IS_USE_AIR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_CITY'
GO
