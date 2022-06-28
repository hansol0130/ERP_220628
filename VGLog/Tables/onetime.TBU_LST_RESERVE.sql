USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[TBU_LST_RESERVE](
	[예약코드] [varchar](20) NOT NULL,
	[상품코드] [varchar](10) NOT NULL,
	[출발일자] [date] NULL,
	[예약자수] [int] NULL,
	[판매금액] [float] NULL,
	[할인금액] [int] NULL,
	[취소유무] [char](1) NULL,
	[취소일] [date] NULL,
	[출발년] [int] NULL,
	[출발월] [int] NULL,
	[고객타입] [varchar](10) NULL
) ON [PRIMARY]
GO
ALTER TABLE [onetime].[TBU_LST_RESERVE] ADD  DEFAULT ((0)) FOR [예약자수]
GO
ALTER TABLE [onetime].[TBU_LST_RESERVE] ADD  DEFAULT ((0)) FOR [할인금액]
GO
ALTER TABLE [onetime].[TBU_LST_RESERVE] ADD  DEFAULT ('N') FOR [취소유무]
GO
