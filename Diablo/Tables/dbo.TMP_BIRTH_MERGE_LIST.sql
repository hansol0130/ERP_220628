USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_BIRTH_MERGE_LIST](
	[ID_NO] [bigint] NULL,
	[중복고객번호] [int] NOT NULL,
	[고객명] [varchar](20) NOT NULL,
	[생년월일] [datetime] NULL,
	[동행고객명] [varchar](40) NULL
) ON [PRIMARY]
GO
