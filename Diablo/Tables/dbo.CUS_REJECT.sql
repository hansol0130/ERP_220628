USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_REJECT](
	[거부일자] [datetime] NULL,
	[CID 번호] [nvarchar](255) NULL,
	[거부신청번호] [nvarchar](255) NULL,
	[거부타입] [float] NULL
) ON [PRIMARY]
GO
