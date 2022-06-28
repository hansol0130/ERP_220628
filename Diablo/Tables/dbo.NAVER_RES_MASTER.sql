USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_RES_MASTER](
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[ALT_MEM_NO] [varchar](40) NULL,
	[BOOK_KEY] [varchar](100) NULL,
	[PRO_CODE] [varchar](30) NULL,
	[PRICE_SEQ] [int] NULL,
	[PRO_NAME] [varchar](1000) NULL,
	[NEW_DATE] [datetime] NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[TOTAL_PRICE] [int] NULL,
	[ADT_COUNT] [int] NULL,
	[CHD_COUNT] [int] NULL,
	[INF_COUNT] [int] NULL,
	[RES_NAME] [varchar](40) NULL,
	[RES_TEL] [varchar](15) NULL,
	[BOOKING_STATE] [varchar](10) NULL,
	[PAY_STATE] [varchar](10) NULL,
	[NEW_CODE] [varchar](7) NULL,
	[EMP_NAME] [varchar](30) NULL,
	[INNER_NUMBER] [varchar](20) NULL,
	[PRO_PC_URL] [varchar](500) NULL,
	[PRO_MOB_URL] [varchar](500) NULL,
	[RES_PC_URL] [varchar](500) NULL,
	[RES_MOB_URL] [varchar](500) NULL,
	[MEET_INFO] [varchar](1000) NULL,
	[TC_CODE] [varchar](100) NULL,
	[TC_YN] [char](1) NULL,
	[TC_NUMBER] [varchar](15) NULL,
	[LAST_UPD_DATE] [datetime] NULL,
	[SEND_DATE] [datetime] NULL,
	[SYSTEM_TYPE] [int] NULL,
	[NATION_CODES] [varchar](400) NULL,
	[CITY_CODES] [varchar](1000) NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'ALT_MEM_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버예약키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'BOOK_KEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드,' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'TOTAL_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'ADT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'CHD_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소아수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'INF_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'RES_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'RES_TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'BOOKING_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'PAY_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'접수자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'접수자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'EMP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'접수자내선번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품PC링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_PC_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품모바일링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_MOB_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약PC링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'RES_PC_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약모바일링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'RES_MOB_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첫만남정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'MEET_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'TC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'TC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'TC_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최근수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'LAST_UPD_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'SEND_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시스템타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER', @level2type=N'COLUMN',@level2name=N'SYSTEM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버예약' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_RES_MASTER'
GO
