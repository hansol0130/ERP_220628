USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_MASTER_NEW](
	[mstCode] [varchar](20) NULL,
	[mstTitle] [nvarchar](4000) NULL,
	[imageUrl] [varchar](300) NULL,
	[createdDate] [varchar](19) NULL,
	[updateDate] [datetime] NULL,
	[updateChildCount] [int] NULL,
	[useYn] [varchar](1) NULL,
	[productFamilyRank] [int] NULL
) ON [PRIMARY]
GO
