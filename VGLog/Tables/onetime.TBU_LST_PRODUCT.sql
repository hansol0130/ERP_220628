USE [VGLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[TBU_LST_PRODUCT](
	[상품코드] [varchar](10) NOT NULL,
	[상품명] [nvarchar](100) NULL,
	[대표지역] [varchar](50) NULL,
	[대표속성] [varchar](50) NULL
) ON [PRIMARY]
GO
