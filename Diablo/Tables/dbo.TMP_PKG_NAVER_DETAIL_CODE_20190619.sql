USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_PKG_NAVER_DETAIL_CODE_20190619](
	[모상품코드] [nvarchar](255) NULL,
	[자상품코드] [nvarchar](255) NULL,
	[상태] [nvarchar](255) NULL,
	[네이버노출] [nvarchar](255) NULL,
	[마지막수정일] [datetime] NULL,
	[DEL_YN] [char](1) NULL
) ON [PRIMARY]
GO
