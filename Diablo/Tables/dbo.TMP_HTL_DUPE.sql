USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_HTL_DUPE](
	[지역] [nvarchar](255) NULL,
	[국가] [nvarchar](255) NULL,
	[도시] [nvarchar](255) NULL,
	[마스터코드] [nvarchar](255) NULL,
	[벤더] [nvarchar](255) NULL,
	[벤더 호텔] [nvarchar](255) NULL,
	[벤더 도시] [nvarchar](255) NULL,
	[마스터이름] [nvarchar](255) NULL,
	[벤더 이름] [nvarchar](255) NULL
) ON [PRIMARY]
GO
