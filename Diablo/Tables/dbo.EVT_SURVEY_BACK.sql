USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_SURVEY_BACK](
	[CUS_NO] [int] NOT NULL,
	[ORDER_BY] [char](2) NOT NULL,
	[REGION_CODE] [char](2) NOT NULL,
	[DAY] [char](2) NOT NULL,
	[PRICE] [char](2) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_DATE] [datetime] NULL
) ON [PRIMARY]
GO
