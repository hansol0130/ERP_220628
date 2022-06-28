USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IPADDRESS_COUNTRY_CODE](
	[SEQ_NO] [int] NOT NULL,
	[NATION_CODE] [char](2) NOT NULL,
	[NATION_NAME] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
