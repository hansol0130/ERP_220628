USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVECARESCENARIO](
	[SCENARIO_NO] [numeric](15, 0) NOT NULL,
	[USER_ID] [varchar](15) NULL,
	[GRP_CD] [varchar](12) NULL,
	[SCENARIO_NM] [varchar](100) NULL,
	[SCENARIO_DESC] [varchar](250) NULL,
	[SCENARIO_TYPE] [char](1) NULL,
	[CREATE_DT] [char](8) NULL,
	[LASTUPDATE_DT] [char](8) NULL,
	[FINISH_YN] [char](1) NULL,
	[FINISH_DT] [char](8) NULL,
	[CREATE_TM] [char](6) NULL,
	[LASTUPDATE_TM] [char](6) NULL,
	[SERVICE_TYPE] [char](1) NULL,
	[TAG_NO] [numeric](10, 0) NULL,
	[SUB_TYPE] [char](1) NULL,
	[HANDLER_TYPE] [char](1) NULL,
	[CHRG_NM] [varchar](30) NULL,
	[BRC_NM] [varchar](30) NULL,
 CONSTRAINT [PK_NVECARESCENARIO] PRIMARY KEY CLUSTERED 
(
	[SCENARIO_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO