USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_EMP_MILEAGE](
	[AGT_CODE] [varchar](10) NOT NULL,
	[EMP_SEQ] [int] NOT NULL,
	[MIL_SEQ] [int] NOT NULL,
	[MIL_PRO_TYPE] [int] NULL,
	[MIL_CODE] [varchar](20) NULL,
	[MIL_NUM] [varchar](20) NULL,
 CONSTRAINT [PK_COM_EMP_MILEAGE] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[EMP_SEQ] ASC,
	[MIL_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMP_MILEAGE', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMP_MILEAGE', @level2type=N'COLUMN',@level2name=N'EMP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마일리지순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMP_MILEAGE', @level2type=N'COLUMN',@level2name=N'MIL_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMP_MILEAGE', @level2type=N'COLUMN',@level2name=N'MIL_PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마일리지사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMP_MILEAGE', @level2type=N'COLUMN',@level2name=N'MIL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마일리지번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMP_MILEAGE', @level2type=N'COLUMN',@level2name=N'MIL_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객사직원마일리지관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_EMP_MILEAGE'
GO
