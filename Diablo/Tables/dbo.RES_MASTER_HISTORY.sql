USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_MASTER_HISTORY](
	[RES_CODE] [char](12) NOT NULL,
	[HIS_SEQ] [int] NOT NULL,
	[PRICE_SEQ] [int] NULL,
	[SYSTEM_TYPE] [int] NOT NULL,
	[PROVIDER] [varchar](10) NULL,
	[MEDIUM_TYPE] [int] NULL,
	[AD_CODE] [varchar](50) NULL,
	[PRO_CODE] [varchar](20) NOT NULL,
	[PRO_NAME] [dbo].[PRO_NAME] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[PRO_TYPE] [int] NOT NULL,
	[RES_STATE] [int] NULL,
	[RES_TYPE] [int] NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[GRP_RES_CODE] [varchar](20) NULL,
	[CUS_NO] [int] NULL,
	[RES_NAME] [varchar](40) NOT NULL,
	[SOC_NUM1] [varchar](6) NULL,
	[SOC_NUM2] [varchar](7) NULL,
	[RES_EMAIL] [varchar](100) NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[ETC_TEL1] [varchar](6) NULL,
	[ETC_TEL2] [varchar](5) NULL,
	[ETC_TEL3] [varchar](4) NULL,
	[RES_ADDRESS1] [varchar](100) NULL,
	[RES_ADDRESS2] [varchar](100) NULL,
	[ZIP_CODE] [varchar](7) NULL,
	[MEMBER_YN] [char](1) NULL,
	[CUS_REQUEST] [nvarchar](4000) NULL,
	[CUS_RESPONSE] [nvarchar](1000) NULL,
	[ETC] [nvarchar](max) NULL,
	[TAX_YN] [char](1) NULL,
	[INSURANCE_YN] [char](1) NULL,
	[SENDING_REMARK] [nvarchar](1000) NULL,
	[MOV_BEFORE_CODE] [varchar](20) NULL,
	[MOV_AFTER_CODE] [varchar](20) NULL,
	[MOV_DATE] [datetime] NULL,
	[COMM_RATE] [numeric](4, 2) NULL,
	[LAST_PAY_DATE] [datetime] NULL,
	[PNR_INFO] [varchar](max) NULL,
	[RES_PRO_TYPE] [int] NULL,
	[SALE_COM_CODE] [varchar](50) NULL,
	[SALE_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[SALE_TEAM_CODE] [varchar](3) NULL,
	[SALE_TEAM_NAME] [varchar](50) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_TEAM_CODE] [varchar](3) NULL,
	[NEW_TEAM_NAME] [varchar](50) NULL,
	[PROFIT_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[PROFIT_TEAM_CODE] [varchar](3) NULL,
	[PROFIT_TEAM_NAME] [varchar](50) NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[CXL_DATE] [datetime] NULL,
	[CXL_CODE] [char](7) NULL,
	[CXL_TYPE] [int] NULL,
	[REFUNDMENT_BANK] [varchar](100) NULL,
	[REFUNDMENT_NAME] [varchar](100) NULL,
	[REFUNDMENT_BANKCODE] [varchar](100) NULL,
	[REFUNDMENT_STATUS] [char](2) NULL,
	[CFM_DATE] [datetime] NULL,
	[CFM_CODE] [dbo].[EMP_CODE] NULL,
	[CARD_PROVE] [varchar](4000) NULL,
	[COMM_AMT] [decimal](18, 0) NULL,
	[sec_SOC_NUM2] [varbinary](16) NULL,
	[sec1_SOC_NUM2] [varchar](28) NULL,
	[IPIN_DUP_INFO] [char](64) NULL,
	[HIS_DATE] [dbo].[NEW_DATE] NULL,
	[HIS_CODE] [char](7) NULL,
 CONSTRAINT [PK_RES_MASTER_HISTORY] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[HIS_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이력순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'HIS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시스템타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'SYSTEM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PROVIDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매체구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'MEDIUM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'광고매체' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'AD_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PRO_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'GRP_RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'SOC_NUM1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자기타연락처1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'ETC_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자기타연락처2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'ETC_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자기타연락처3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'ETC_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자주소1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자주소2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'MEMBER_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객요청사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CUS_REQUEST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객전달사항' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CUS_RESPONSE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'ETC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세금계산서유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'TAX_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보험가입유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'INSURANCE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'센딩비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'SENDING_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약이동전예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'MOV_BEFORE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약이동후예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'MOV_AFTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약이동일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'MOV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'COMM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금마감일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'LAST_PAY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PNR정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PNR_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약상품속성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'SALE_COM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'SALE_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'SALE_TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약접수자팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'SALE_TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매실적자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PROFIT_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매실적팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PROFIT_TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매실적팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'PROFIT_TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약취소일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약취소자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 개인사정(질병, 일정변경), 2 : 모객부족, 3 :  항공불능, 4 : 타여행사연결, 5 : 여권 비자, 6 :  타사상품전도, 7 : 이중예약, 8 : 천재지변(기상악화), 9 : 항공연결불능, 10 : 상품가격차이, 11 : 패고객서비스부실, 12 : 예약금 미납, 13 : 기타취소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CXL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불은행및카드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'REFUNDMENT_BANK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불은행예금주' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'REFUNDMENT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불은행계좌번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'REFUNDMENT_BANKCODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환불상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'REFUNDMENT_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약확인일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CFM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약확인자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CFM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카드증빙' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'CARD_PROVE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'COMM_AMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호뒷자리_암호화필드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'sec_SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주민번호뒷자리_암호화필드2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'sec1_SOC_NUM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이핀DI값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'IPIN_DUP_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정이력일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'HIS_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정이력자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY', @level2type=N'COLUMN',@level2name=N'HIS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약마스터이력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_MASTER_HISTORY'
GO
