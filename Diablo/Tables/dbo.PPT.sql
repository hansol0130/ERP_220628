USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PPT](
	[영문성] [varchar](6) NOT NULL,
	[영문이름] [varchar](6) NOT NULL,
	[성별] [varchar](6) NOT NULL,
	[생년월일] [varchar](6) NOT NULL,
	[발급일] [varchar](6) NOT NULL,
	[만료일] [varchar](6) NOT NULL
) ON [PRIMARY]
GO
