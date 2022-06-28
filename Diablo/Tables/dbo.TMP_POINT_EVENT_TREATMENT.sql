USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_POINT_EVENT_TREATMENT](
	[고객번호] [int] NOT NULL,
	[CUS_NAME] [varchar](20) NULL,
	[GENDER] [char](1) NULL,
	[BIRTH_DATE] [datetime] NULL,
	[나이] [int] NULL,
	[포인트번호] [int] NOT NULL,
	[포인트타입] [int] NOT NULL,
	[적립구분] [int] NOT NULL,
	[적립금액] [money] NOT NULL,
	[적립일] [datetime] NOT NULL,
	[가입일] [datetime] NULL,
	[최초출발일] [datetime] NULL
) ON [PRIMARY]
GO
