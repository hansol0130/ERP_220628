USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_MASTER](
	[AGT_CODE] [varchar](10) NOT NULL,
	[AGT_ID] [varchar](20) NULL,
	[PARENT_AGT_CODE] [varchar](10) NULL,
	[COMPANY_NUMBER] [varchar](20) NULL,
	[CON_START_DATE] [datetime] NULL,
	[CON_END_DATE] [datetime] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_SEQ] [int] NULL,
	[SALE_RATE] [decimal](4, 2) NULL,
 CONSTRAINT [PK_COM_MASTER] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[COM_MASTER] ADD  DEFAULT ((0.0)) FOR [SALE_RATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모기업코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'PARENT_AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'법인번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'COMPANY_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계약기간시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'CON_START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계약기간종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'CON_END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'복지몰할인율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER', @level2type=N'COLUMN',@level2name=N'SALE_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MASTER'
GO
