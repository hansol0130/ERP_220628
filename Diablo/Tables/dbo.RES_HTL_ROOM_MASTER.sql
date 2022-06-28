USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_HTL_ROOM_MASTER](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[RES_STATE] [int] NULL,
	[CHECK_IN] [datetime] NULL,
	[CHECK_OUT] [datetime] NULL,
	[CITY_CODE] [varchar](10) NULL,
	[SUP_CODE] [varchar](10) NULL,
	[SUP_RES_CODE] [varchar](20) NULL,
	[LAST_CXL_DATE] [datetime] NULL,
	[VOUCHER_NO] [varchar](50) NULL,
	[ROOM_YN] [char](1) NULL,
	[SALE_PRICE] [int] NULL,
	[TAX_PRICE] [int] NULL,
	[DC_PRICE] [int] NULL,
	[CHG_PRICE] [int] NULL,
	[PENALTY_PRICE] [int] NULL,
	[NET_PRICE] [int] NULL,
	[HTL_REMARK] [nvarchar](max) NULL,
	[CXL_REMARK] [varchar](4000) NULL,
	[NEW_CODE] [dbo].[EMP_CODE] NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [dbo].[EMP_CODE] NULL,
	[EDT_DATE] [datetime] NULL,
	[CXL_CODE] [dbo].[EMP_CODE] NULL,
	[CXL_DATE] [datetime] NULL,
	[VOUCHER_INFO] [varchar](1000) NULL,
	[POINT_RATE] [decimal](4, 2) NULL,
	[POINT_PRICE] [int] NULL,
	[EVENT_SEQ] [int] NULL,
	[NON_REFUND_YN] [char](1) NULL,
	[HOTEL_NAME] [varchar](200) NULL,
 CONSTRAINT [PK_RES_HTL_ROOM_MASTER] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_HTL_ROOM_MASTER]  WITH CHECK ADD FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_MASTER_damo] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' ( 0 : 확인요망, 1 : 대기, 2 : 확정, 3 : 부분확정, 4 : 취소, 5 : 취소대기, 6 : 불가, 7 : 계류, 8 : 에러, 9 : 전송실패 )  ->  ( 0 : None, 1 : 확정, 2 : 대기, 3 : 취소, 4 : 취소대기중, 5 : 펜딩, 6 : 확인요망, 7 : 환불요청중, 8 : 환불, 9 : 알수없음 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'RES_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체크인날자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'CHECK_IN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체크아웃날자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'CHECK_OUT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급자코드 ( 0 : 전체, 1 : GTA, 2 : RTS, 3 : VGT ) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'SUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급자예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'SUP_RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소마감일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'LAST_CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'바우처번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'VOUCHER_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'ROOM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'SALE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DC가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'DC_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'변동금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'CHG_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'PENALTY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'NET_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'HTL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소규정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'CXL_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'바우처정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'VOUCHER_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트 비율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'POINT_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'POINT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'EVENT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불불가여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'NON_REFUND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER', @level2type=N'COLUMN',@level2name=N'HOTEL_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔예약룸정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_MASTER'
GO
