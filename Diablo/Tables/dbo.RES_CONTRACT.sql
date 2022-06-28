USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_CONTRACT](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[CONTRACT_NO] [int] NOT NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[NIGHT] [int] NULL,
	[INS_TYPE] [int] NULL,
	[INS_PRICE] [int] NULL,
	[MIN_COUNT] [int] NULL,
	[MAX_COUNT] [int] NULL,
	[TRANS_TYPE] [int] NULL,
	[TRANS_GRADE] [varchar](20) NULL,
	[STAY_TYPE] [varchar](30) NULL,
	[STAY_COUNT] [varchar](10) NULL,
	[TC_YN] [char](1) NULL,
	[TRANSPORT_TYPE] [int] NULL,
	[TRANSPORT_COUNT] [int] NULL,
	[MANDATORY_1] [char](1) NULL,
	[MANDATORY_2] [char](1) NULL,
	[MANDATORY_4] [char](1) NULL,
	[MANDATORY_5] [char](1) NULL,
	[MANDATORY_6] [char](1) NULL,
	[MANDATORY_7] [char](1) NULL,
	[MANDATORY_3] [char](1) NULL,
	[OPTION_1] [char](1) NULL,
	[OPTION_2] [char](1) NULL,
	[OPTION_3] [char](1) NULL,
	[OPTION_4] [char](1) NULL,
	[OPTION_5] [char](1) NULL,
	[OPTION_6] [char](1) NULL,
	[OPTION_7] [char](1) NULL,
	[OPTION_8] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[TOUR_TYPE] [int] NULL,
	[INSIDE_DAY] [int] NULL,
	[REMARK] [varchar](max) NULL,
	[CFM_YN] [dbo].[USE_N] NULL,
	[CFM_DATE] [datetime] NULL,
	[CFM_TYPE] [int] NULL,
	[CFM_HEADER] [varchar](max) NULL,
	[CFM_IP] [varchar](20) NULL,
	[PRO_NAME] [nvarchar](100) NULL,
	[ADT_PRICE] [int] NULL,
	[DEP_DEP_DATE] [datetime] NULL,
	[ARR_ARR_DATE] [datetime] NULL,
	[DEP_AIRPORT] [varchar](40) NULL,
	[ARR_AIRPORT] [varchar](40) NULL,
	[RSV_DATE] [datetime] NULL,
	[PAYMENT_YN] [char](1) NULL,
	[RES_COUNT] [int] NULL,
	[TOTAL_PRICE] [int] NULL,
	[CONT_DATE] [dbo].[NEW_DATE] NULL,
	[SPC_TERMS_INFO] [varchar](max) NULL,
	[CONT_NAME] [varchar](40) NULL,
	[INS_YN] [char](1) NULL,
 CONSTRAINT [PK_RES_CONTRACT] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[CONTRACT_NO] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_CONTRACT] ADD  CONSTRAINT [DF__RES_CONTR__ADT_P__0F0E1094]  DEFAULT ((0)) FOR [ADT_PRICE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CONTRACT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행박수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'NIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 영업보증, 1 : 공제, 2 : 예치금 ( 영업보증 = 0 , 공제 = 1, 예치금 = 2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'INS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험 계약금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'INS_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최소인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MIN_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 항공기, 1 : 선박, 2 : 기차, 9 : 기타 ( 항공기 = 0 , 선박 = 1 , 기차 = 2 , 기타 = 9 ) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TRANS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교통수단 등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TRANS_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 특급, 1 : 준특급, 2 : 스탠다드, 3 : 비지니스, 4 : 유스호스텔, 5 : 민박, 99 : 기타 ( 특급 = 0 , 준특급 = 1, 스탠다드 = 2, 비지니스 = 3, 유스호스텔 = 4, 민박 = 5, 일급 = 6, 기타 = 99)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'STAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'투숙인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'STAY_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행인솔자 유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 버스, 1 : 승용차, 9 : 기타 ( 버스 = 0 , 승용차 = 1 , 기타 = 9) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TRANSPORT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현지교통 인승' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TRANSPORT_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'필수항목1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'필수항목2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'필수항목4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'필수항목5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'필수항목6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_6'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'필수항목7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_7'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'필수항목3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'MANDATORY_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션항목1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션항목2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션항목3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션항목4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션항목5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션항목6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_6'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션항목7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_7'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'옵션항목8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'OPTION_8'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 기획, 1 : 희망 ( 기획 = 0 , 희망 = 1)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TOUR_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기내숙박' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'INSIDE_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동의일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : EMAIL, 1 : HOMEPAGE, 2 : 직접수령 ( EMAIL = 0 ,  MYPAGE = 1, 직접수령 =2 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동의헤더값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_HEADER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동의IP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CFM_IP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'ADT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한국출발' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'DEP_DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한국도착' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'ARR_ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한국출발공항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'현지출발공항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'RSV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'완납여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'PAYMENT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약출발자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'RES_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'TOTAL_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계약일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CONT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'특별약관' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'SPC_TERMS_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계약명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'CONT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자 보험 여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT', @level2type=N'COLUMN',@level2name=N'INS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자계약서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CONTRACT'
GO
