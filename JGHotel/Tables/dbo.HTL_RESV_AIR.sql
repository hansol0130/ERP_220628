USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_RESV_AIR](
	[AIR_NO] [int] NOT NULL,
	[RESV_ID] [varchar](50) NULL,
	[RESV_NO] [int] NULL,
	[PNR_SEQNO] [int] NULL,
	[PNR_NO] [varchar](10) NULL,
	[ITIN_CONTENT] [varchar](4000) NULL,
	[AIR_CD] [varchar](2) NULL,
	[AIR_NM] [varchar](200) NULL,
	[CITY_CD] [varchar](3) NULL,
	[CITY_NM] [varchar](300) NULL,
	[DEP_DATE] [varchar](14) NULL,
	[DSC_RATE] [int] NULL,
	[DSC_AMT] [decimal](18, 0) NULL,
	[CREATE_DATE] [datetime] NULL
) ON [PRIMARY]
GO
