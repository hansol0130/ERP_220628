USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_RTS_LOCATION](
	[국가코드] [nvarchar](255) NULL,
	[국가명] [nvarchar](255) NULL,
	[도시코드] [nvarchar](255) NULL,
	[도시명] [nvarchar](255) NULL,
	[호텔코드] [nvarchar](255) NULL,
	[위치명] [nvarchar](255) NULL,
	[위치코드] [nvarchar](255) NULL
) ON [PRIMARY]
GO
