USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OTR_MASTER](
	[OTR_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[PRO_CODE] [varchar](20) NOT NULL,
	[OTR_STATE] [char](1) NOT NULL,
	[EDI_CODE] [char](10) NOT NULL,
	[TOTAL_VALUATION] [int] NULL,
	[AGT_GRADE] [varchar](1) NULL,
	[APP_CODE] [char](7) NULL,
	[REF_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NOT NULL,
 CONSTRAINT [PK_OTR_MASTER] PRIMARY KEY CLUSTERED 
(
	[OTR_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'OTR_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 미작성, 1 : 작성중, 2 : 결재중, 3 : 작성완료, 4 : 재검토' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'OTR_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 ~ 5 점' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'TOTAL_VALUATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : A, 1 : B, 2 : C, 3 : D, 4 : E' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'APP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참조자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'REF_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장보고서마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OTR_MASTER'
GO
