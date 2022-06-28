USE [Cuve]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_APRIORI_INPUT](
	[예약순번] [bigint] NULL,
	[예약코드] [varchar](24) NULL,
	[예약시간] [datetime] NULL,
	[IP주소] [varchar](20) NULL,
	[RES_MASTER] [varchar](10) NULL,
	[OPEN_MASTER] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
