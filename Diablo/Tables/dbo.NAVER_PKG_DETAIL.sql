USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL](
	[mstCode] [varchar](20) NOT NULL,
	[mstTitle] [nvarchar](2000) NOT NULL,
	[childCode] [varchar](30) NOT NULL,
	[childTitle] [nvarchar](2000) NOT NULL,
	[createdDate] [datetime] NOT NULL,
	[updatedDate] [datetime] NULL,
	[isEmergency] [varchar](5) NOT NULL,
	[urlInfo_landingPc] [varchar](500) NOT NULL,
	[urlInfo_landingMobile] [varchar](500) NOT NULL,
	[urlInfo_imageS] [nvarchar](max) NULL,
	[countryList] [nvarchar](200) NULL,
	[cityList] [nvarchar](500) NULL,
	[beginDate] [varchar](10) NULL,
	[beginCityCode] [char](3) NULL,
	[beginRideType] [varchar](10) NULL,
	[beginFlight_airlineCode] [char](2) NULL,
	[beginFlight_flightName] [varchar](10) NULL,
	[beginFlight_codeShareName] [varchar](10) NULL,
	[beginFlight_departureDate] [datetime] NULL,
	[beginFlight_transfer] [int] NULL,
	[beginFlight_seatGrade] [varchar](20) NULL,
	[beginFlight_upgradable] [varchar](5) NULL,
	[beginFlight_durationTime] [int] NULL,
	[beginFlight_isMileage] [varchar](5) NULL,
	[beginFlight_mileageAirline] [varchar](10) NULL,
	[beginFlight_mileageCost] [int] NULL,
	[beginFlight_mileageDescription] [varchar](50) NULL,
	[beginShip_shipCode] [varchar](3) NULL,
	[beginShip_durationTime] [int] NULL,
	[beginShip_departureDate] [datetime] NULL,
	[endDate] [varchar](10) NULL,
	[endCityCode] [char](3) NULL,
	[endRideType] [varchar](10) NULL,
	[endFlight_airlineCode] [char](2) NULL,
	[endFlight_flightName] [varchar](10) NULL,
	[endFlight_codeShareName] [varchar](10) NULL,
	[endFlight_arriveDate] [datetime] NULL,
	[endFlight_transfer] [int] NULL,
	[endFlight_seatGrade] [varchar](20) NULL,
	[endFlight_upgradable] [varchar](5) NULL,
	[endFlight_durationTime] [int] NULL,
	[endFlight_isMileage] [varchar](5) NULL,
	[endFlight_mileageAirline] [varchar](10) NULL,
	[endFlight_mileageCost] [int] NULL,
	[endFlight_mileageDescription] [varchar](50) NULL,
	[endShip_shipCode] [varchar](3) NULL,
	[endShip_durationTime] [int] NULL,
	[endShip_arriveDate] [datetime] NULL,
	[travelPeriod_night] [int] NULL,
	[travelPeriod_day] [int] NULL,
	[priceInfo_adult_basePrice] [int] NULL,
	[priceInfo_adult_surcharge] [int] NULL,
	[priceInfo_adult_total] [int] NULL,
	[priceInfo_adult_localPrice] [int] NULL,
	[priceInfo_adult_localCurrency] [varchar](3) NULL,
	[priceInfo_child_basePrice] [int] NULL,
	[priceInfo_child_surcharge] [int] NULL,
	[priceInfo_child_total] [int] NULL,
	[priceInfo_child_localPrice] [int] NULL,
	[priceInfo_child_localCurrency] [varchar](3) NULL,
	[priceInfo_infant_basePrice] [int] NULL,
	[priceInfo_infant_surcharge] [int] NOT NULL,
	[priceInfo_infant_total] [int] NULL,
	[priceInfo_infant_localPrice] [int] NULL,
	[priceInfo_infant_localCurrency] [varchar](3) NULL,
	[priceInfo_infant_description] [varchar](10) NOT NULL,
	[priceInfo_serviceCharge_serviceName] [varchar](50) NOT NULL,
	[priceInfo_serviceCharge_price] [int] NULL,
	[priceInfo_serviceCharge_currency] [varchar](3) NULL,
	[productIn] [nvarchar](300) NULL,
	[productOut] [nvarchar](300) NULL,
	[productSellingPoints] [nvarchar](2000) NULL,
	[productPoints_traffic] [nvarchar](2000) NULL,
	[productPoints_stay] [nvarchar](2000) NULL,
	[productPoints_tour] [nvarchar](2000) NULL,
	[productPoints_eat] [nvarchar](2000) NULL,
	[productPoints_discount] [nvarchar](2000) NULL,
	[productPoints_other] [nvarchar](2000) NULL,
	[tourOption_isOptionalTour] [varchar](5) NOT NULL,
	[tourOption_isFreeSchedule] [varchar](5) NOT NULL,
	[shoppingTimeNum] [int] NULL,
	[bookingStatus_seatAll] [int] NULL,
	[bookingStatus_seatMin] [int] NULL,
	[bookingStatus_seatNow] [int] NOT NULL,
	[bookingStatus_bookingCode] [varchar](5) NOT NULL,
	[productType] [varchar](10) NOT NULL,
	[productThemeList] [varchar](200) NOT NULL,
	[reviewCount] [int] NULL,
	[gradeCount] [int] NULL,
	[guideStatus] [varchar](10) NULL,
	[hashtag] [nvarchar](4000) NULL,
	[isCombine] [varchar](5) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[productRank] [int] NULL,
	[callNumber] [varchar](10) NULL,
	[isNoTips] [varchar](5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'mstCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'mstTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'childCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'childTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'createdDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'updatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'isEmergency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????PC??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'urlInfo_landingPc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'urlInfo_landingMobile'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'urlInfo_imageS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????(??????????????????)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'countryList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????(??????????????????)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'cityList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginCityCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginRideType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_airlineCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_flightName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_codeShareName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_departureDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_transfer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_seatGrade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_upgradable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_durationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_isMileage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_mileageAirline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_mileageCost'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_mileageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginShip_shipCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginShip_durationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginShip_departureDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endCityCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endRideType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_airlineCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_flightName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_codeShareName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_arriveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_transfer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_seatGrade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_upgradable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_durationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_isMileage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_mileageAirline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_mileageCost'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_mileageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endShip_shipCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endShip_durationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endShip_arriveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'travelPeriod_night'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'travelPeriod_day'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_basePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_surcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_total'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_localPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_localCurrency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_basePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_surcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_total'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_localPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_localCurrency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_basePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_surcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_total'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_localPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_localCurrency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_serviceCharge_serviceName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_serviceCharge_price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_serviceCharge_currency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productIn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productOut'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productSellingPoints'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_traffic'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_stay'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_tour'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_eat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_discount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_other'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'tourOption_isOptionalTour'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'tourOption_isFreeSchedule'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'shoppingTimeNum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'bookingStatus_seatAll'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'bookingStatus_seatMin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'bookingStatus_seatNow'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'bookingStatus_bookingCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productThemeList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'reviewCount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'gradeCount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????,?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'guideStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'hashtag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'isCombine'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productRank'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'callNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'isNoTips'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL'
GO
