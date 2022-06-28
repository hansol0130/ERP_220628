USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_CUSTOMER_damo](
	[RES_CODE] [char](12) NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[RES_STATE] [int] NULL,
	[SEAT_YN] [char](1) NULL,
	[CUS_TYPE] [int] NULL,
	[CUS_GRADE] [int] NULL,
	[CUS_NO] [int] NULL,
	[CUS_NAME] [varchar](40) NULL,
	[LAST_NAME] [varchar](20) NULL,
	[FIRST_NAME] [varchar](20) NULL,
	[AGE_TYPE] [int] NULL,
	[GENDER] [char](1) NULL,
	[SOC_NUM1] [varchar](6) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[EMAIL] [varchar](40) NULL,
	[NATIONAL] [char](2) NULL,
	[APIS_YN] [char](1) NOT NULL,
	[VISA_YN] [char](1) NULL,
	[PASS_YN] [char](1) NULL,
	[PASS_EXPIRE] [datetime] NULL,
	[PASS_ISSUE] [datetime] NULL,
	[SALE_PRICE] [int] NULL,
	[CHG_PRICE] [int] NULL,
	[DC_PRICE] [int] NULL,
	[TAX_PRICE] [int] NULL,
	[PENALTY_PRICE] [int] NULL,
	[PENALTY_YN] [char](1) NULL,
	[CHG_REMARK] [nvarchar](max) NULL,
	[SENDING_REMARK] [nvarchar](1000) NULL,
	[ROOMING_REMARK] [nvarchar](1000) NULL,
	[ETC_REMARK] [nvarchar](1000) NULL,
	[RETURN_YN] [char](1) NULL,
	[ROOMING] [varchar](2) NULL,
	[POINT_PRICE] [int] NULL,
	[POINT_YN] [char](1) NULL,
	[POINT_REF] [int] NULL,
	[CUS_INS_YN] [char](1) NULL,
	[INS_CODE] [varchar](10) NULL,
	[INS_SEQ] [int] NULL,
	[INS_PRICE] [int] NULL,
	[INS_DAY] [int] NULL,
	[COMM_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [datetime] NULL,
	[CXL_DATE] [datetime] NULL,
	[CXL_CODE] [char](7) NULL,
	[MOV_RES_CODE] [char](12) NULL,
	[COMM_RATE] [decimal](13, 1) NULL,
	[COMM_AMT] [decimal](13, 0) NULL,
	[POINT_RATE] [decimal](4, 2) NULL,
	[row_id] [uniqueidentifier] NULL,
	[sec_SOC_NUM2] [varbinary](16) NULL,
	[sec1_SOC_NUM2] [varchar](28) NULL,
	[sec_PASS_NUM] [varbinary](32) NULL,
	[IPIN_DUP_INFO] [char](64) NULL,
	[IPIN_CONN_INFO] [char](88) NULL,
	[CALL_CODE] [char](7) NULL,
	[CALL_DATE] [datetime] NULL,
	[VIEW_YN] [char](1) NULL,
	[FIRST_QCHARGE] [int] NULL,
	[FIRST_QCHARGE_DATE] [datetime] NULL,
	[BIRTH_DATE] [datetime] NULL,
	[PPT_NO] [int] NULL,
	[FILE_NO] [int] NULL,
	[FAX_SEQ] [char](17) NULL,
	[TICKET] [varchar](10) NULL,
 CONSTRAINT [PK_RES_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DEF_NUM_1_458067525]  DEFAULT ((0)) FOR [RES_STATE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DEF_RES_CUSTOMER_CUS_TYPE]  DEFAULT ((0)) FOR [CUS_TYPE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DEF_NUM_1_588605758]  DEFAULT ((0)) FOR [AGE_TYPE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DEF_RES_CUSTOMER_APIS_YN]  DEFAULT ('N') FOR [APIS_YN]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_SALE_PRICE]  DEFAULT ((0)) FOR [SALE_PRICE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_CHG_PRICE]  DEFAULT ((0)) FOR [CHG_PRICE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_DC_PRICE]  DEFAULT ((0)) FOR [DC_PRICE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_TAX_PRICE]  DEFAULT ((0)) FOR [TAX_PRICE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_PENALTY_PRICE]  DEFAULT ((0)) FOR [PENALTY_PRICE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_PENALTY_YN]  DEFAULT ('N') FOR [PENALTY_YN]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_POINT_PRICE]  DEFAULT ((0)) FOR [POINT_PRICE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DEF_RES_CUSTOMER_CUS_INS_YN]  DEFAULT ('N') FOR [CUS_INS_YN]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_INS_PRICE]  DEFAULT ((0)) FOR [INS_PRICE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_COMM_YN]  DEFAULT ('N') FOR [COMM_YN]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_COMM_RATE]  DEFAULT ((0)) FOR [COMM_RATE]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DF_RES_CUSTOMER_COMM_AMT]  DEFAULT ((0)) FOR [COMM_AMT]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [RES_CUSTOMER_df_rowid]  DEFAULT (newid()) FOR [row_id]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  DEFAULT ('Y') FOR [VIEW_YN]
GO
ALTER TABLE [dbo].[RES_CUSTOMER_damo] ADD  CONSTRAINT [DEF_RES_CUSTOMER_FIRST_QCHARGE]  DEFAULT ((0)) FOR [FIRST_QCHARGE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 예약, 1 : 취소, 2 : 이동, 3 : 환불, 4 : 페널티, 9 : 전체' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'RES_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SEAT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(0 : 일반, 1 : TC, 2 : 가이드) ( 일반 = 0 , TC =  1, 가이드 = 2 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 성인, 1: 아동, 2 : 유아' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'AGE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성별' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SOC_NUM1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국적' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NATIONAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아피스등록여부 ( None = 0 , 완료 = 1 , 미완료 = 2 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'APIS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비자여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'VISA_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PASS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권만료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PASS_EXPIRE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권발급일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PASS_ISSUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SALE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'변동금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CHG_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DC금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'DC_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'TAX_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PENALTY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소료부가여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PENALTY_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'변동내역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CHG_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'센딩비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'SENDING_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'방배정비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'ROOMING_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'ETC_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리턴유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'RETURN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'루밍' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'ROOMING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'POINT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트적립유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'POINT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트적립번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'POINT_REF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험가입여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CUS_INS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'INS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'INS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'INS_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'INS_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'COMM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이동한예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'MOV_RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'COMM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'COMM_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트 비율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'POINT_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이핀DI값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'IPIN_DUP_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이핀CI값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'IPIN_CONN_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통화자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CALL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통화시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'CALL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마이페이지노출여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'VIEW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FIRST_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초유류할증료기준일                                                                                              ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FIRST_QCHARGE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권수신번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'PPT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FILE_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo', @level2type=N'COLUMN',@level2name=N'FAX_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약출발자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_CUSTOMER_damo'
GO
