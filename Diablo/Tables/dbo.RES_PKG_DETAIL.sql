USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_PKG_DETAIL](
	[RES_CODE] [char](12) NOT NULL,
	[AIR_GDS] [int] NULL,
	[HOTEL_GDS] [int] NULL,
	[AIR_PNR] [varchar](10) NULL,
	[HOTEL_VOUCHER] [varchar](20) NULL,
	[AIR_ONLINE_YN] [char](1) NULL,
	[HOTEL_ONLINE_YN] [char](1) NULL,
	[BRANCH_RATE] [int] NULL,
 CONSTRAINT [PK_RES_PKG_DETAIL] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_PKG_DETAIL] ADD  DEFAULT ((0)) FOR [BRANCH_RATE]
GO
ALTER TABLE [dbo].[RES_PKG_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK__RES_PKG_D__RES_C__11007AA7] FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_MASTER_damo] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_PKG_DETAIL] CHECK CONSTRAINT [FK__RES_PKG_D__RES_C__11007AA7]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : Direct, 1 :Topas, 2 : Abacus, 3 : Galileo, 4 : WorldSpan,  5 : ATR, 6 : ETC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'AIR_GDS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔GDS ( 0 : Direct, 1 : HotelPass, 2 : Tourico, 3 : Gta )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'HOTEL_GDS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공 PNR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'AIR_PNR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔바우처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'HOTEL_VOUCHER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공실시간여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'AIR_ONLINE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔실시간여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'HOTEL_ONLINE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알선수수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'BRANCH_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품예약세부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_PKG_DETAIL'
GO
