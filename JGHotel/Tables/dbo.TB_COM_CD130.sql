USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_COM_CD130](
	[CITY_CD] [varchar](50) NOT NULL,
	[NA_CD] [varchar](50) NOT NULL,
	[CITY_KOR_NM] [varchar](200) NULL,
	[CITY_ENG_NM] [varchar](200) NULL,
	[DI_FLAG] [varchar](50) NULL,
	[STATE_CD] [varchar](50) NULL,
	[STATE_NM] [varchar](200) NULL,
	[SRH_KWRD] [varchar](500) NULL,
	[TMDIFF] [decimal](18, 0) NULL,
	[TMDIFF_INDICT_YN] [varchar](50) NULL,
	[MULTI_AIRPORT_YN] [varchar](50) NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](50) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](50) NULL,
	[DSCNT_AIR_CITY_FLAG] [varchar](50) NULL
) ON [PRIMARY]
GO
