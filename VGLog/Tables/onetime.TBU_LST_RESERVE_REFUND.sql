USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[TBU_LST_RESERVE_REFUND](
	[예약코드] [varchar](20) NOT NULL,
	[취소인원] [int] NULL,
	[취소금액] [float] NULL,
	[취소일] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [onetime].[TBU_LST_RESERVE_REFUND] ADD  DEFAULT ((0)) FOR [취소인원]
GO
