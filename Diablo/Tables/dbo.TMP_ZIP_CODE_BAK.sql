USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_ZIP_CODE_BAK](
	[ZIP_CODE] [char](6) NOT NULL,
	[SEQ] [char](3) NULL,
	[SIDO] [varchar](50) NULL,
	[GUGUN] [varchar](50) NULL,
	[DONG] [varchar](50) NULL,
	[RI] [varchar](50) NULL,
	[DOSU] [varchar](50) NULL,
	[BUNJI] [varchar](50) NULL,
	[BUILDING] [varchar](100) NULL,
	[EDTDATE] [char](8) NULL,
	[ADDRESS] [varchar](255) NULL
) ON [PRIMARY]
GO
