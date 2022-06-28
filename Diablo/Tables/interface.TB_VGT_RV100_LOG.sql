USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [interface].[TB_VGT_RV100_LOG](
	[LOG_NO] [varchar](25) NOT NULL,
	[LOG_CREAT_FLAG] [varchar](1) NOT NULL,
	[PNR_SEQNO] [int] NOT NULL,
	[AGT_CD] [varchar](10) NULL,
	[RSV_NO] [varchar](10) NULL,
	[ALPHA_PNR_NO] [varchar](10) NULL,
	[DVICE_TYPE] [varchar](20) NULL,
	[DI_FLAG] [varchar](1) NULL,
	[GDS_CD] [varchar](2) NULL,
	[BCNC_CD] [varchar](50) NULL,
	[BPLC_CD] [varchar](10) NULL,
	[RSV_USR_ID] [varchar](50) NULL,
	[RSV_USR_NM] [varchar](50) NULL,
	[TRIP_TYPE_CD] [varchar](20) NULL,
	[DEP_DTM] [varchar](14) NULL,
	[ARR_DTM] [varchar](14) NULL,
	[DEP_CITY_CD] [varchar](5) NULL,
	[PURPS_CITY_CD] [varchar](5) NULL,
	[STOCK_AIR_CD] [varchar](2) NULL,
	[AIR_NO_CD] [varchar](4) NULL,
	[PAY_TL] [varchar](14) NULL,
	[AIR_TTL] [varchar](14) NULL,
	[ON_OFF_RSV_FLAG] [varchar](3) NULL,
	[SALE_TOT_AMT] [int] NULL,
	[PNR_SEAT_STATUS_CD] [varchar](2) NULL,
	[RSV_STATUS_CD] [varchar](6) NULL,
	[PAY_STATUS_CD] [varchar](6) NULL,
	[ISSUE_STATUS_CD] [varchar](6) NULL,
	[RSV_DTM] [varchar](14) NULL,
	[ALL_ITIN_CONTENT] [varchar](4000) NULL,
	[RSV_INWON] [int] NULL,
	[EMAIL] [varchar](4000) NULL,
	[MPHONE_NO] [varchar](4000) NULL,
	[CPNY_TEL_NO] [varchar](4000) NULL,
	[SALE_FORM_CD] [varchar](5) NULL,
	[SALE_DEPT_CD] [varchar](10) NULL,
	[SALE_USR_ID] [varchar](50) NULL,
	[CHRG_DEPT_CD] [varchar](50) NULL,
	[CHRG_USR_ID] [varchar](50) NULL,
	[UPPER_ISSUE_DEPT_CD] [varchar](10) NULL,
	[ISSUE_DATE] [varchar](8) NULL,
	[ISSUE_USR_ID] [varchar](50) NULL,
	[AREA_ROUTE_CD] [varchar](10) NULL,
	[CANCEL_YN] [varchar](1) NULL,
	[CANCEL_DTM] [varchar](14) NULL,
	[ARR_AIRPORT_CD] [varchar](3) NULL,
	[IF_SYS_RSV_NO] [varchar](50) NULL,
	[SYNC_TYPE] [varchar](50) NULL,
	[REG_USR_ID] [varchar](50) NULL,
	[REG_DTM] [varchar](14) NULL,
	[UPD_USR_ID] [varchar](50) NULL,
	[UPD_DTM] [varchar](14) NULL,
PRIMARY KEY CLUSTERED 
(
	[LOG_NO] ASC,
	[LOG_CREAT_FLAG] ASC,
	[PNR_SEQNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [interface].[TB_VGT_RV100_LOG] ADD  DEFAULT ('N') FOR [CANCEL_YN]
GO
ALTER TABLE [interface].[TB_VGT_RV100_LOG] ADD  DEFAULT (CONVERT([varchar](10),getdate(),(112))+replace(CONVERT([varchar](8),getdate(),(108)),':','')) FOR [REG_DTM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'로그 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'LOG_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'로그 생성 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'LOG_CREAT_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 일련번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'PNR_SEQNO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행사코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'AGT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'RSV_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알파 예약 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'ALPHA_PNR_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'장치 타입 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'DVICE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국제선 / 국내선 구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'DI_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GDS 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'GDS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'BCNC_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사업장코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'BPLC_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'RSV_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 사용자 명' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'RSV_USR_NM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행 유형 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'TRIP_TYPE_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'DEP_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'ARR_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발도시 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'DEP_CITY_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'목적도시 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'PURPS_CITY_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'STOCK 항공사 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'STOCK_AIR_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사 숫자 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'AIR_NO_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제시한' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'PAY_TL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사발권시한' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'AIR_TTL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'온라인 오프라인 예약구분' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'ON_OFF_RSV_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매총금액' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'SALE_TOT_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR 좌석 상태 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'PNR_SEAT_STATUS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약상태 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'RSV_STATUS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결제상태코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'PAY_STATUS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권상태코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'ISSUE_STATUS_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'RSV_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전체 여정 내용' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'ALL_ITIN_CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약인원' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'RSV_INWON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이동 전화 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'MPHONE_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회사 전화 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'CPNY_TEL_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매 형태 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'SALE_FORM_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매 부서 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'SALE_DEPT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'SALE_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당 부서 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'CHRG_DEPT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'CHRG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상위 발권 부서 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'UPPER_ISSUE_DEPT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권일자' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발권 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'ISSUE_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역 노선 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'AREA_ROUTE_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소 여부' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'CANCEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'CANCEL_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착 공항 코드' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인터페이스 시스템 예약 번호' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'IF_SYS_RSV_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동기화 타입' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'SYNC_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'REG_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'REG_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 사용자 ID' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'UPD_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 일시' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG', @level2type=N'COLUMN',@level2name=N'UPD_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공예약로그' , @level0type=N'SCHEMA',@level0name=N'interface', @level1type=N'TABLE',@level1name=N'TB_VGT_RV100_LOG'
GO
