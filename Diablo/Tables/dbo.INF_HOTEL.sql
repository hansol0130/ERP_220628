USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_HOTEL](
	[CNT_CODE] [dbo].[CNT_CODE] NOT NULL,
	[STAY_CODE] [char](1) NULL,
	[GRADE] [int] NULL,
	[ADDRESS] [nvarchar](200) NULL,
	[SHORT_LOCATION] [nvarchar](200) NULL,
	[TEL_NUMBER] [varchar](50) NULL,
	[FAX_NUMBER] [varchar](50) NULL,
	[HOMEPAGE] [varchar](500) NULL,
	[BREAD_YN] [char](1) NULL,
	[BREAD_INFO] [nvarchar](30) NULL,
	[CHECK_IN_TIME] [varchar](5) NULL,
	[CHECK_OUT_TIME] [varchar](5) NULL,
	[AROUND_AIRPORT] [nvarchar](30) NULL,
	[DISTANCE_AIRPORT] [varchar](200) NULL,
	[DETAIL_LOCATION] [nvarchar](max) NULL,
	[FLR_COUNT] [int] NULL,
	[ROOM_COUNT] [int] NULL,
	[TRANS_INFO] [nvarchar](1000) NULL,
	[ROOM_INFO] [nvarchar](1000) NULL,
	[ATTRIBUTE_INFO] [nvarchar](1000) NULL,
	[USE_VOLTAGE] [varchar](20) NULL,
	[HTL_INTRO] [nvarchar](1000) NULL,
 CONSTRAINT [PK_INF_HOTEL] PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'STAY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'간략위치' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'SHORT_LOCATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'홈페이지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조식제공여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'BREAD_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조식정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'BREAD_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체크인시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'CHECK_IN_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체크아웃시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'CHECK_OUT_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주변공항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'AROUND_AIRPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주변공항과의거리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'DISTANCE_AIRPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세위치' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'DETAIL_LOCATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'건물층수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'FLR_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸갯수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'ROOM_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교통편' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'TRANS_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'객실정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'ROOM_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부대시설정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'ATTRIBUTE_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용전압' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'USE_VOLTAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔소개' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL', @level2type=N'COLUMN',@level2name=N'HTL_INTRO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔컨텐츠' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL'
GO
