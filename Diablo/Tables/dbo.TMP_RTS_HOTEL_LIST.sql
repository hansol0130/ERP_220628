USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_RTS_HOTEL_LIST](
	[호텔코드] [varchar](10) NOT NULL,
	[호텔명] [nvarchar](255) NULL,
	[현지명] [nvarchar](255) NULL,
	[영문명] [nvarchar](255) NULL,
	[국가코드] [nvarchar](255) NULL,
	[국가명] [nvarchar](255) NULL,
	[주코드] [nvarchar](255) NULL,
	[도시코드] [varchar](10) NULL,
	[도시명] [nvarchar](255) NULL,
	[X좌표] [nvarchar](255) NULL,
	[Y좌표] [nvarchar](255) NULL,
	[호텔설명] [nvarchar](max) NULL,
	[등급] [nvarchar](255) NULL,
	[주소] [nvarchar](255) NULL,
	[찾아가는방법] [nvarchar](max) NULL,
	[전화번호] [nvarchar](255) NULL,
	[팩스번호] [nvarchar](255) NULL,
	[홈페이지URL] [nvarchar](max) NULL,
	[사용유무] [nvarchar](255) NULL,
	[조식제공여부] [nvarchar](255) NULL,
	[조석정보] [nvarchar](255) NULL,
	[체크인 시간] [nvarchar](255) NULL,
	[체크아웃 시간] [nvarchar](255) NULL,
	[가까운 공항] [nvarchar](255) NULL,
	[층수] [nvarchar](255) NULL,
	[룸수] [nvarchar](255) NULL,
	[룸 정보] [nvarchar](255) NULL,
	[사용전압] [nvarchar](255) NULL,
	[부대시설] [nvarchar](255) NULL,
	[로케이션코드] [varchar](100) NULL,
 CONSTRAINT [PK_TMP_RTS_HOTEL_LIST_1] PRIMARY KEY CLUSTERED 
(
	[호텔코드] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'RTS의 호텔 정보테이블(삭제금지)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TMP_RTS_HOTEL_LIST'
GO
