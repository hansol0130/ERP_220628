USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_MANTOMAN_BOARD](
	[BD_NO] [int] NOT NULL,
	[RESV_NO] [int] NULL,
	[BD_TYPE] [varchar](50) NULL,
	[BD_CONTENTS] [varchar](8000) NULL,
	[BD_CREATE_DATE] [datetime] NULL,
	[AW_YN] [varchar](1) NULL,
	[AW_CONTENTS] [varchar](8000) NULL,
	[AW_CREATE_DATE] [datetime] NULL,
	[AW_CREATE_USER] [varchar](50) NULL
) ON [PRIMARY]
GO
