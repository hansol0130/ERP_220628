USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_EMPLOYEE_MATCHING](
	[AGT_CODE] [varchar](10) NOT NULL,
	[EMP_SEQ] [int] NOT NULL,
	[CUS_NO] [int] NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
 CONSTRAINT [PK_COM_EMPLOYEE_MATCHING] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[EMP_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE_MATCHING', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직원순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE_MATCHING', @level2type=N'COLUMN',@level2name=N'EMP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE_MATCHING', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE_MATCHING', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE_MATCHING', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직원매핑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMPLOYEE_MATCHING'
GO
