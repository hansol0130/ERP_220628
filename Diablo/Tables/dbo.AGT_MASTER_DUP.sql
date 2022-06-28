USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGT_MASTER_DUP](
	[AGT_CODE] [varchar](10) NOT NULL,
	[AGT_REGISTER] [char](10) NULL,
	[KOR_NAME] [varchar](50) NULL,
	[ENG_NAME] [varchar](30) NULL,
	[CEO_NAME] [varchar](50) NULL,
	[AGT_CONDITION] [varchar](30) NULL,
	[AGT_ITEM] [varchar](30) NULL,
	[AGT_TYPE_CODE] [char](2) NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[ADDRESS1] [varchar](100) NULL,
	[ADDRESS2] [varchar](100) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[FAX_TEL2] [varchar](5) NULL,
	[FAX_TEL1] [varchar](6) NULL,
	[FAX_TEL3] [varchar](4) NULL,
	[AGT_MGR_NAME] [varchar](20) NULL,
	[AGT_MGR_TEL1] [varchar](6) NULL,
	[AGT_MGR_TEL2] [varchar](5) NULL,
	[AGT_MGR_TEL3] [varchar](4) NULL,
	[AGT_MGR_EMAIL] [varchar](50) NULL,
	[ADMIN_REMARK] [varchar](300) NULL,
	[SHOW_YN] [dbo].[USE_Y] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[URL] [varchar](50) NULL,
	[AGT_PART_CODE] [char](2) NULL,
	[USE_CODE] [varchar](10) NULL,
	[AGT_NAME] [varchar](50) NULL,
	[SYS_YN] [char](1) NULL,
	[AGT_GRADE] [varchar](1) NULL,
	[AREA_CODE] [varchar](25) NULL
) ON [PRIMARY]
GO
