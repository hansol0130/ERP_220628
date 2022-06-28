USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BBS_COP_SCHEDULE](
	[SEQ] [dbo].[SEQ_NO] IDENTITY(1,1) NOT NULL,
	[COMPANY] [varchar](100) NULL,
	[PERIOD] [varchar](30) NULL,
	[GOAL] [varchar](50) NULL,
	[RES_COUNT] [varchar](50) NULL,
	[LAND] [varchar](50) NULL,
	[RES_CODE] [char](12) NULL,
	[PRO_CODE] [varchar](20) NULL,
	[MANAGER] [varchar](50) NULL,
	[TC] [varchar](50) NULL,
	[CONFIRM] [varchar](30) NULL,
	[REMARK] [varchar](100) NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[SCH_DATE] [datetime] NOT NULL,
	[SUBJECT] [varchar](200) NULL,
	[CONTENTS] [varchar](max) NULL,
	[FONT_COLOR] [varchar](20) NULL,
	[ALT_TIME] [datetime] NULL,
	[ALT_YN] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[START_TIME] [datetime] NULL,
	[END_TIME] [datetime] NULL,
	[TEAM_CODE] [dbo].[TEAM_CODE] NULL,
	[REGION_CODE] [char](3) NULL,
	[STATUS] [char](1) NULL,
	[SCH_GRADE] [char](1) NULL,
	[GDS] [char](1) NULL,
	[AIRLINE_CODE] [char](2) NULL,
	[PNR_CODE] [varchar](20) NULL,
 CONSTRAINT [PK_BBS_COP_SCHEDULE] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
