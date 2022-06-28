USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_RV120](
	[PNR_SEQNO] [int] NOT NULL,
	[ITIN_NO] [int] NOT NULL,
	[ITIN_TATOO_NO] [varchar](5) NULL,
	[ITIN_BUNDLE_UNIT] [varchar](2) NULL,
	[FLTNO] [varchar](6) NULL,
	[DEP_CITY_CD] [varchar](5) NULL,
	[DEP_AIRPORT_CD] [varchar](3) NULL,
	[DEP_DATE] [varchar](8) NULL,
	[DEP_TM] [varchar](4) NULL,
	[ARR_CITY_CD] [varchar](5) NULL,
	[ARR_AIRPORT_CD] [varchar](3) NULL,
	[ARR_DATE] [varchar](8) NULL,
	[ARR_TM] [varchar](4) NULL,
	[CABIN_SEAT_GRAD] [varchar](1) NULL,
	[RSV_SEAT_GRAD] [varchar](3) NULL,
	[SALE_AIR_CD] [varchar](3) NULL,
	[FLT_AIR_CD] [varchar](3) NULL,
	[AIR_RSV_NO] [varchar](12) NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[PNR_SEQNO] ASC,
	[ITIN_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_RV120] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여정번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'ITIN_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여정 타투 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'ITIN_TATOO_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여정묶음단위' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'ITIN_BUNDLE_UNIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비행편명' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'FLTNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발도시코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'DEP_CITY_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발공항코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발 일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발 시각' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'DEP_TM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착도시코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'ARR_CITY_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착공항코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착 일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착 시각' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'ARR_TM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'캐빈 좌석 등급' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'CABIN_SEAT_GRAD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 좌석 등급' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'RSV_SEAT_GRAD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매 항공사 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'SALE_AIR_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운항 항공사 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'FLT_AIR_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사 예약 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'AIR_RSV_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공여정' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV120'
GO
