USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARG_CUSTOMER](
	[ARG_CODE] [varchar](12) NOT NULL,
	[CUS_SEQ_NO] [int] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[SEQ_NO] [int] NULL,
	[ARG_STATUS] [int] NULL,
	[CUS_NAME] [dbo].[CUS_NAME] NULL,
	[LAST_NAME] [varchar](20) NULL,
	[FIRST_NAME] [varchar](20) NULL,
	[AGE_TYPE] [int] NULL,
	[GENDER] [char](1) NULL,
	[BIRTH_DATE] [varchar](10) NULL,
	[EMAIL] [varchar](100) NULL,
	[CELLPHONE] [varchar](16) NULL,
	[PASS_NUM] [varchar](20) NULL,
	[PASS_EXPIRE] [datetime] NULL,
	[ROOMING] [varchar](2) NULL,
	[ETC_REMAKR] [nvarchar](1000) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_ARG_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[ARG_CODE] ASC,
	[CUS_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'ARG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배확정명단번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'CUS_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약출발자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 성인, 1 : 아동, 2 : 유아' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'AGE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'M:남 F:여' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'휴대폰번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'CELLPHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PASS_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권만료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PASS_EXPIRE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'ROOMING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'ETC_REMAKR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배 확정명단' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_CUSTOMER'
GO
