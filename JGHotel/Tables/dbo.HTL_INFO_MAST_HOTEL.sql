USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_INFO_MAST_HOTEL](
	[HOTEL_CODE] [int] NOT NULL,
	[NAME] [nvarchar](500) NULL,
	[ENG_NAME] [nvarchar](500) NULL,
	[CITY_CODE] [int] NULL,
	[CITY_NAME] [varchar](500) NULL,
	[AREA_CODE] [bigint] NULL,
	[AREA_NAME] [varchar](500) NULL,
	[LOCATION_DESC] [varchar](500) NULL,
	[HOTEL_TYPE] [varchar](100) NULL,
	[ADDRESS] [varchar](2000) NULL,
	[AIRPORT_CODE] [varchar](10) NULL,
	[STAR_RATING] [decimal](17, 1) NULL,
	[ROOM_CNT] [varchar](50) NULL,
	[CHECK_IN_TIME] [varchar](50) NULL,
	[CHECK_OUT_TIME] [varchar](50) NULL,
	[LATITUDE] [varchar](50) NULL,
	[LONGITUDE] [varchar](50) NULL,
	[MAIN_IMG] [varchar](200) NULL,
	[RV_POINT] [decimal](16, 2) NULL,
	[RV_CNT] [int] NULL,
	[RECOM_SORT] [int] NULL,
	[RECOM_YN] [varchar](100) NULL,
	[REMARK] [varchar](5000) NULL,
	[USE_YN] [varchar](1) NULL,
	[INFO_FROM] [varchar](2) NULL,
	[CHAIN_ID] [varchar](100) NULL,
	[CHAIN_NAME] [varchar](100) NULL,
	[BRAND_ID] [varchar](100) NULL,
	[BRAND_NAME] [varchar](100) NULL,
	[ZIPCODE] [varchar](100) NULL,
	[STATE] [varchar](100) NULL,
	[COUNTRY_NAME] [varchar](100) NULL,
	[COUNTRYISOCODE] [varchar](10) NULL,
	[NUMBERFLOORS] [varchar](10) NULL,
	[YEAR_OPENED] [varchar](10) NULL,
	[YEAR_RENOVATED] [varchar](10) NULL,
	[OVERVIEW] [varchar](8000) NULL,
	[CONTINENT_ID] [varchar](10) NULL,
	[CONTINENT_NAME] [varchar](100) NULL,
	[COUNTRY_ID] [varchar](10) NULL,
	[HOTEL_URL] [varchar](500) NULL,
	[INFANT_AGE] [varchar](10) NULL,
	[CHILDREN_AGE_FROM] [varchar](10) NULL,
	[CHILDREN_AGE_TO] [varchar](10) NULL,
	[CHILDREN_STAY_FREE] [varchar](10) NULL,
	[MIN_GUEST_AGE] [varchar](10) NULL,
	[PHONE] [varchar](50) NULL,
	[FAX] [varchar](20) NULL,
	[UPDATE_TYPE] [varchar](4) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](30) NULL,
	[UPDATE_DATE] [datetime] NULL,
	[UPDATE_USER] [varchar](30) NULL,
 CONSTRAINT [PK_HTL_INFO_MAST_HOTEL] PRIMARY KEY CLUSTERED 
(
	[HOTEL_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
