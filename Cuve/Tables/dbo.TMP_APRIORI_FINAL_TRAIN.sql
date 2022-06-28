USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_APRIORI_FINAL_TRAIN](
	[SEQ] [int] NULL,
	[NO] [int] NOT NULL,
	[마스터코드] [varchar](100) NOT NULL,
	[지지도] [varchar](8000) NULL,
	[예약상품] [varchar](8000) NULL
) ON [PRIMARY]
GO
