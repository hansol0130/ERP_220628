USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_PROVIDER](
	[PROVIDER] [int] NOT NULL,
	[CODE] [varchar](20) NOT NULL,
	[FLAG] [char](1) NULL,
 CONSTRAINT [PK_PKG_PROVIDER] PRIMARY KEY CLUSTERED 
(
	[PROVIDER] ASC,
	[CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : None, 1 : 직판, 2 : 간판여행사, 3 : 간판랜드사, 4 : 대리점, 5 : 인터넷 ,6 : 항공조인여행사, 7 : 항공조인랜드사, 8 : LandyOnly, 9 : 타사전도, 10 : 삼성TnE, 11 : 멤플러스, 12 : 멤플러스, 13 : _인터파크, 14 : 멤플러스, 15 : _큐비, 16 : G마켓, 17 : 신한카드, 18 : 웅진메키아, 19 : 롯데카드, 20 : 무궁화관광, 21 : 다음쇼핑, 22 : 모바일앱, 23 : 네이버쇼핑, 24 : 네이버_광주, 25 : 네이버_부산, 26 : 크리테오, 27 : CBS투어, 28 : 와이더플래닛, 29 : 와이더플래닛_터키, 30 : 와이더플래닛_항공호텔, 31 : 현대카드, 32 : KB국민카드, 33 : 십일번가, 34 : 구글, 35 : BTMS, 36 : 하나카드, 37 : BTMS_복지몰, 38 : 티켓몬스터, 39 : 삼성카드, 40 : 옥션, 41 : NH카드, 42 : 카카오항공, 43 : 네이버, 90 : 네티웰' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_PROVIDER', @level2type=N'COLUMN',@level2name=N'PROVIDER'
GO
