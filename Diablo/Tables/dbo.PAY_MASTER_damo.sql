USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_MASTER_damo](
	[PAY_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[PAY_TYPE] [int] NULL,
	[PAY_SUB_TYPE] [varchar](50) NULL,
	[PAY_SUB_NAME] [varchar](50) NULL,
	[AGT_CODE] [varchar](10) NULL,
	[ACC_SEQ] [int] NULL,
	[PAY_METHOD] [int] NULL,
	[PAY_NAME] [varchar](80) NULL,
	[PAY_PRICE] [int] NULL,
	[COM_RATE] [decimal](4, 2) NULL,
	[COM_PRICE] [decimal](12, 2) NULL,
	[PAY_DATE] [datetime] NULL,
	[PAY_REMARK] [varchar](200) NULL,
	[ADMIN_REMARK] [varchar](300) NULL,
	[CUS_NO] [dbo].[CUS_NO] NULL,
	[INSTALLMENT] [int] NULL,
	[EDI_CODE] [varchar](10) NULL,
	[CLOSED_CODE] [char](7) NULL,
	[CLOSED_YN] [char](1) NULL,
	[CLOSED_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[CXL_YN] [dbo].[USE_N] NULL,
	[CXL_DATE] [dbo].[CANCEL_DATE] NULL,
	[CXL_CODE] [dbo].[CANCEL_CODE] NULL,
	[sec_PAY_NUM] [varbinary](112) NULL,
	[sec1_PAY_NUM] [varchar](400) NULL,
	[PG_APP_NO] [varchar](20) NULL,
	[MALL_ID] [varchar](10) NULL,
 CONSTRAINT [PK_PAY_MASTER] PRIMARY KEY CLUSTERED 
(
	[PAY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAY_MASTER_damo] ADD  CONSTRAINT [DF__PAY_MASTE__COM_P__63E3BB6D]  DEFAULT ((0)) FOR [COM_PRICE]
GO
ALTER TABLE [dbo].[PAY_MASTER_damo] ADD  CONSTRAINT [DF__PAY_MASTE__CLOSE__62EF9734]  DEFAULT ('N') FOR [CLOSED_YN]
GO
ALTER TABLE [dbo].[PAY_MASTER_damo] ADD  CONSTRAINT [DEF_PAY_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[PAY_MASTER_damo] ADD  CONSTRAINT [DEF_PAY_MASTER_CXL_YN]  DEFAULT ('N') FOR [CXL_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈμλ²' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : μν, 1 : μΌλ°κ³μ’, 2 : OFFμ μ©μΉ΄λ, 3 : PGμ μ©μΉ΄λ, 4 : μνκΆ, 5 : νκΈ, 6 : λ―Έμλμ²΄, 7 : ν¬μΈνΈ_νμκ°μ, 8 : κΈ°ν, 9 : μΈκΈκ³μ°μ, 10 : CCCF, 11 : IND_TKT, 12 : TASF, 13 : ARS, 14 : ARSνΈμ ν, 15 : κ°μκ³μ’, 16 : λ€μ΄λ²νμ΄_μ μ©μΉ΄λ, 17 : λ€μ΄λ²νμ΄_κ³μ’μ΄μ²΄, 18 : λ€μ΄λ²νμ΄_ν¬μΈνΈ, 19 : SMSPay, 71 : ν¬μΈνΈ_κ΅¬λ§€μ€μ , 999 : μμ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈμΈλΆκ΅¬λΆ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_SUB_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈμΈλΆκ΅¬λΆλͺ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_SUB_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'κ±°λμ²μ½λ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'κ³μ’μλ²' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ACC_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(0 : ννμ΄μ§, 1 : EMAI,L 2 : μ§μ λ°©λ¬Έ, 3 : μ ν, 4 : μν) ( ννμ΄μ§ = 0, EMAIL = 1, μ§μ λ°©λ¬Έ = 2, μ ν = 3 , μν = 4, μλ = 8, μμ€ν = 9 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_METHOD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈκ³ κ°λͺ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈκΈμ‘' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μμλ£μ¨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'COM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μμλ£' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'COM_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈμΌμ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈλΉκ³ ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PAY_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'κ΄λ¦¬μλΉκ³ ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ADMIN_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'νμμ½λ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ν λΆκ°μμ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INSTALLMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μ μκ²°μ λ¬Έμλ²νΈ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈλ§κ°μ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CLOSED_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈλ§κ°μ¬λΆ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CLOSED_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈλ§κ°μΌ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CLOSED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μμ±μμ½λ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μμ±μΌ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μμ μμ½λ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μμ μΌ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μ·¨μμ¬λΆ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μ·¨μμΌ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μ·¨μμμ½λ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CXL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'κ²°μ λ²νΈ_μνΈννλ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'sec_PAY_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'κ²°μ λ²νΈ_μνΈννλ2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'sec1_PAY_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PGμΉμΈλ²νΈ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PG_APP_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'λͺ°ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MALL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'μκΈλ§μ€ν°' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_MASTER_damo'
GO
