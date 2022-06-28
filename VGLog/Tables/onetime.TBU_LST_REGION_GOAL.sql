USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[TBU_LST_REGION_GOAL](
	[대표지역] [varchar](50) NULL,
	[목표년도] [int] NULL,
	[목표월] [int] NULL,
	[매출목표] [float] NULL
) ON [PRIMARY]
GO
