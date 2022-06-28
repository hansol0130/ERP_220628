USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ZIP_CODE_ROAD](
	[ZIP_CODE] [char](6) NULL,
	[SEQ] [char](3) NULL,
	[SIDO] [varchar](50) NULL,
	[GUGUN] [varchar](50) NULL,
	[DONG] [varchar](50) NULL,
	[ROAD_CODE] [varchar](20) NULL,
	[ROAD_NAME] [varchar](500) NULL,
	[IS_UNDER] [int] NULL,
	[BD_NUM1] [int] NULL,
	[BD_NUM2] [int] NULL,
	[PLACE_NAME] [varchar](300) NULL,
	[LAW_DONG] [varchar](300) NULL,
	[REMARK] [varchar](300) NULL
) ON [PRIMARY]
GO
