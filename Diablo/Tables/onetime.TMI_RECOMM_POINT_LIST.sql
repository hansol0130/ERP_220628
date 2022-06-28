USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[TMI_RECOMM_POINT_LIST](
	[고객명(닉네임)] [nvarchar](255) NULL,
	[고객번호] [nvarchar](255) NULL,
	[전화번호] [nvarchar](255) NULL,
	[초대친구수] [float] NULL,
	[가입일자] [datetime] NULL,
	[포인트 지급(P)] [float] NULL
) ON [PRIMARY]
GO
