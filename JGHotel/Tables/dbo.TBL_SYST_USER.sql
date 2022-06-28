USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_SYST_USER](
	[USER_ID] [varchar](30) NOT NULL,
	[USER_NAME] [varchar](20) NULL,
	[PASSWORD] [varchar](50) NULL,
	[MCPN_CODE] [varchar](6) NULL,
	[USERGRP_CODE] [varchar](4) NULL,
	[MCPNGRP_CODE] [char](4) NULL,
	[POSITION_CODE] [varchar](6) NULL,
	[IP_ADDRESS] [varchar](15) NULL,
	[USE_YN] [char](1) NULL,
	[CONTACT_TEL] [varchar](20) NULL,
	[CONTACT_FAX] [varchar](20) NULL,
	[CONTACT_EMAIL] [varchar](50) NULL,
	[USER_ROLE] [varchar](100) NULL,
	[BIGO] [varchar](500) NULL,
	[UPD_ID] [varchar](9) NULL,
	[UPD_DATE] [datetime] NULL,
	[REG_DATE] [datetime] NULL,
	[DEBUG_YN] [char](1) NULL,
	[JG_YN] [varchar](1) NULL,
	[USER_PHOTO] [varchar](max) NULL,
	[USER_ADDRESS] [varchar](50) NULL,
	[CONTACT_MESSANGER] [varchar](50) NULL,
	[JOIN_DATE] [datetime] NULL,
	[RESIGN_DATE] [datetime] NULL,
	[USER_RANK] [varchar](50) NULL,
	[CONTACT_LINE] [varchar](20) NULL,
	[VG_ID] [varchar](30) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
