USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_KEYWORD_DICTIONARY$](
	[NO] [float] NULL,
	[KEYWORD] [nvarchar](255) NULL,
	[CATEGORY] [nvarchar](255) NULL,
	[REGION] [nvarchar](255) NULL,
	[NATION] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL
) ON [PRIMARY]
GO
