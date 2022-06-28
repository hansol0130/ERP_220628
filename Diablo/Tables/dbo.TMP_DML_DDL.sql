USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_DML_DDL](
	[Lsn] [char](22) NULL,
	[Name] [varchar](30) NULL,
	[ObjectName] [nvarchar](257) NULL,
	[ParentName] [nvarchar](257) NULL,
	[Date] [datetime] NULL,
	[TransactionID] [char](13) NULL
) ON [PRIMARY]
GO
