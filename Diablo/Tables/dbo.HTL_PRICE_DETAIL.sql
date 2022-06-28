USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_PRICE_DETAIL](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[PRICE_SEQ] [int] NOT NULL,
	[BOOKING_DATE] [datetime] NOT NULL,
	[ROOM_NAME] [varchar](30) NULL,
	[WEEKDAY_TYPE] [int] NULL,
	[BREAKFAST_NAME] [varchar](30) NULL,
	[ROOM_COUNT] [int] NULL,
	[RES_COUNT] [int] NULL,
	[LAST_CXL_DATE] [datetime] NULL,
	[CXL_PRICE_INFO] [varchar](300) NULL,
	[NET_PRICE] [int] NULL,
	[SELLER_PRICE] [int] NULL,
	[PRICE_REMARK] [varchar](30) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_HTL_PRICE_DETAIL] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[PRICE_SEQ] ASC,
	[BOOKING_DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HTL_PRICE_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_375] FOREIGN KEY([MASTER_CODE], [PRICE_SEQ])
REFERENCES [dbo].[HTL_PRICE_MASTER] ([MASTER_CODE], [PRICE_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HTL_PRICE_DETAIL] CHECK CONSTRAINT [R_375]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'BOOKING_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'ROOM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'WEEKDAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조식명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'BREAKFAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총객실수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'ROOM_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약객실수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소마감일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'LAST_CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소금액정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'CXL_PRICE_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'원가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'NET_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'SELLER_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'PRICE_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'활성여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔가격상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_DETAIL'
GO
