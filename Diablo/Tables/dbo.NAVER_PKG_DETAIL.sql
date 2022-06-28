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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'mstCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모상품명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'mstTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'childCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'childTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'createdDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'updatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'긴급모객여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'isEmergency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품PC링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'urlInfo_landingPc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품모바일링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'urlInfo_landingMobile'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자상품대표이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'urlInfo_imageS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드(방문국가전체)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'countryList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드(방문도시전체)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'cityList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패키지출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발지도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginCityCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발편탑승타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginRideType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_airlineCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_flightName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발실제탑승편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_codeShareName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편출발시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_departureDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편경유횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_transfer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편좌석등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_seatGrade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편좌석업그레이드여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_upgradable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편비행시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_durationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편마일리지적립여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_isMileage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편마일리지적립항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_mileageAirline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편마일리지적립포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_mileageCost'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공편마일리지적립추가설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginFlight_mileageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발선박코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginShip_shipCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발선박항해시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginShip_durationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발선박출발시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'beginShip_departureDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패키지도착일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착지도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endCityCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착지탑승타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endRideType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_airlineCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_flightName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착실제탑승편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_codeShareName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편도착시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_arriveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편경유횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_transfer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편좌석등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_seatGrade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편좌석업그레이드여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_upgradable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편비행시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_durationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편마일리지적립여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_isMileage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편마일리지적립항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_mileageAirline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편마일리지적립포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_mileageCost'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공편마일리지적립추가설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endFlight_mileageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착선박코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endShip_shipCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착선박항해시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endShip_durationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착선박도착시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'endShip_arriveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'travelPeriod_night'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행기간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'travelPeriod_day'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인기본상품가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_basePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_surcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인총상품가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_total'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인현지필수경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_localPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인현지필수경비통화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_adult_localCurrency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동기본상품가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_basePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_surcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동총상품가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_total'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동현지필수경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_localPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동현지필수경비통화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_child_localCurrency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소아기본상품가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_basePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소아유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_surcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소아총상품가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_total'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소아현지필수경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_localPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소아현지필수경비통화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_localCurrency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'소아설명문구비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_infant_description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추가서비스명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_serviceCharge_serviceName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추가서비스금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_serviceCharge_price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추가서비스금액통화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'priceInfo_serviceCharge_currency'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품포함내역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productIn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품불포함내역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productOut'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productSellingPoints'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품교통셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_traffic'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품숙박셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_stay'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품관광셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_tour'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품식사셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_eat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품할인증정셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_discount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품기타셀링포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productPoints_other'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선택관광유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'tourOption_isOptionalTour'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자유일정유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'tourOption_isFreeSchedule'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쇼핑센터방문횟수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'shoppingTimeNum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약총좌석수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'bookingStatus_seatAll'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최소출발인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'bookingStatus_seatMin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현재예약인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'bookingStatus_seatNow'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약상태코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'bookingStatus_bookingCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품테마코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productThemeList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리뷰수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'reviewCount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평점' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'gradeCount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인솔자,현지가이드상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'guideStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'해시태그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'hashtag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연합상품여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'isCombine'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품노출순위' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'productRank'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문의연락처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'callNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노팁유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL', @level2type=N'COLUMN',@level2name=N'isNoTips'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버자상품' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL'
GO
