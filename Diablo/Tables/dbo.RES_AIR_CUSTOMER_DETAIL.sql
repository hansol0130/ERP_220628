USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_AIR_CUSTOMER_DETAIL](
	[SEQ_NO] [int] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[STAY_ADDRESS] [varchar](200) NULL,
	[STAY_TEL] [varchar](50) NULL,
	[MILEAGE_REF] [varchar](20) NULL,
	[DEP_MILEAGE_REF] [varchar](20) NULL,
	[DEP_AIRLINE_CODE] [char](2) NULL,
	[DEP_DC_CODE] [varchar](10) NULL,
	[DEP_DC_NAME] [varchar](200) NULL,
	[DEP_DC_RATE] [decimal](5, 2) NULL,
	[ARR_MILEAGE_REF] [varchar](20) NULL,
	[ARR_AIRLINE_CODE] [char](2) NULL,
	[ARR_DC_CODE] [varchar](10) NULL,
	[ARR_DC_NAME] [varchar](200) NULL,
	[ARR_DC_RATE] [decimal](5, 2) NULL,
	[BIRTH_DAY] [varchar](10) NULL,
	[STAY_NATION] [varchar](10) NULL,
	[STAY_CITY_CODE] [varchar](10) NULL,
	[STAY_ZIP_CODE] [varchar](10) NULL,
	[PASS_ISSUE_NATION] [char](2) NULL,
	[NATIONALITY] [char](3) NULL,
 CONSTRAINT [PK_RES_AIR_CUSTOMER_DETAIL] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_AIR_CUSTOMER_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK__RES_AIR_CUSTOMER__71BCD978] FOREIGN KEY([RES_CODE], [SEQ_NO])
REFERENCES [dbo].[RES_CUSTOMER_damo] ([RES_CODE], [SEQ_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_AIR_CUSTOMER_DETAIL] CHECK CONSTRAINT [FK__RES_AIR_CUSTOMER__71BCD978]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체류지주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'STAY_ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체류지전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'STAY_TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마일리지번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'MILEAGE_REF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발마일리지카드번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_MILEAGE_REF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발할인종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_DC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발할인명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_DC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발할인율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'DEP_DC_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착마일리지카드번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_MILEAGE_REF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착할인종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_DC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착할인명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_DC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착할인율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'ARR_DC_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'BIRTH_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박지국가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'STAY_NATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박지도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'STAY_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'숙박지우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'STAY_ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권발급국가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'PASS_ISSUE_NATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국적' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'NATIONALITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공 출발자 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_AIR_CUSTOMER_DETAIL'
GO
