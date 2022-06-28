USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROAD_ADDR_CODE](
	[도로명코드] [varchar](12) NOT NULL,
	[도로명] [varchar](80) NOT NULL,
	[도로명로마자] [nvarchar](80) NULL,
	[읍면동일련번호] [varchar](2) NOT NULL,
	[시도명] [varchar](40) NULL,
	[시도로마자] [nvarchar](40) NULL,
	[시군구명] [varchar](40) NULL,
	[시군구로마자] [nvarchar](40) NULL,
	[읍면동명] [varchar](40) NULL,
	[읍면동로마자] [nvarchar](40) NULL,
	[읍면동구분] [char](1) NULL,
	[읍면동코드] [char](3) NULL,
	[사용여부] [char](1) NULL,
	[변경사유] [char](1) NULL,
	[변경이력정보] [varchar](14) NULL,
	[고시일자] [varchar](8) NULL,
	[말소일자] [varchar](8) NULL,
 CONSTRAINT [ROAD_ADDR_CODE_PK1] PRIMARY KEY CLUSTERED 
(
	[도로명코드] ASC,
	[읍면동일련번호] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
