USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HBS_DETAIL_TEMP](
	[MASTER_SEQ] [int] NOT NULL,
	[BOARD_SEQ] [int] NOT NULL,
	[CATEGORY_SEQ] [int] NOT NULL,
	[PARENT_SEQ] [int] NOT NULL,
	[LEVEL] [int] NOT NULL,
	[STEP] [int] NOT NULL,
	[SUBJECT] [nvarchar](200) NULL,
	[CONTENTS] [text] NULL,
	[SHOW_COUNT] [int] NULL,
	[NOTICE_YN] [char](1) NULL,
	[DEL_YN] [char](1) NULL,
	[IP_ADDRESS] [varchar](15) NULL,
	[COMPLETE_YN] [char](1) NULL,
	[FILE_PATH] [nvarchar](255) NULL,
	[EDIT_PASS] [varchar](60) NULL,
	[LOCK_YN] [char](1) NULL,
	[MASTER_CODE] [varchar](20) NULL,
	[CNT_CODE] [int] NULL,
	[REGION_NAME] [varchar](30) NULL,
	[NICKNAME] [varchar](20) NULL,
	[PHONE_NUM] [varchar](30) NULL,
	[EMAIL] [varchar](50) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [int] NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
	[GOOD_TYPE_CD] [char](1) NULL,
	[AREA_CD] [char](2) NULL,
	[GOOD_YY] [char](4) NULL,
	[GOOD_SEQ] [int] NULL,
	[SEARCH_PK] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
