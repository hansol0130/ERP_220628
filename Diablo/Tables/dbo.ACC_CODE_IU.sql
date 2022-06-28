USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACC_CODE_IU](
	[CD_FG] [char](4) NOT NULL,
	[CD] [varchar](20) NOT NULL,
	[CD_NM] [varchar](40) NULL,
	[DZ_CODE] [varchar](40) NULL,
	[DZ_NAME] [varchar](40) NULL,
	[REMARK] [varchar](100) NULL,
	[DEL_YN] [char](1) NULL
) ON [PRIMARY]
GO
