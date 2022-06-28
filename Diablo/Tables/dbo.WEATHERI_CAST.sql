USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WEATHERI_CAST](
	[W_CITY_CODE] [varchar](10) NULL,
	[CAST_DATE] [varchar](8) NULL,
	[WEATHER_CODE] [varchar](2) NULL,
	[WEATHER_TEXT] [varchar](20) NULL,
	[MIN_TEMPER] [varchar](6) NULL,
	[MAX_TEMPER] [varchar](6) NULL,
	[RAIN_AMT] [varchar](7) NULL,
	[WIND_SPD] [varchar](6) NULL,
	[MIN_HUMD] [varchar](3) NULL,
	[AVG_HUMD] [varchar](3) NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'강수량' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WEATHERI_CAST', @level2type=N'COLUMN',@level2name=N'RAIN_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'풍속' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WEATHERI_CAST', @level2type=N'COLUMN',@level2name=N'WIND_SPD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최소습도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WEATHERI_CAST', @level2type=N'COLUMN',@level2name=N'MIN_HUMD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평균습도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WEATHERI_CAST', @level2type=N'COLUMN',@level2name=N'AVG_HUMD'
GO
