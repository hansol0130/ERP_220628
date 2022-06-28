USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_COM_CD190](
	[AIRPORT_CD] [varchar](50) NOT NULL,
	[AIRPORT_KOR_NM] [varchar](200) NULL,
	[AIRPORT_ENG_NM] [varchar](200) NULL,
	[CITY_CD] [varchar](50) NULL,
	[USE_YN] [varchar](50) NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](50) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](50) NULL
) ON [PRIMARY]
GO
