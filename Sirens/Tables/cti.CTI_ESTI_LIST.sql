USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_ESTI_LIST](
	[ESTI_WOL] [char](6) NOT NULL,
	[SHEET_CODE] [int] NOT NULL,
	[EMP_CODE] [char](7) NOT NULL,
	[ITEM_CODE] [char](4) NOT NULL,
	[ITEM_VALUE] [int] NOT NULL,
	[ITEM_MEMO] [nvarchar](1000) NULL,
 CONSTRAINT [PK_CTI_ESTI_LIST] PRIMARY KEY CLUSTERED 
(
	[ESTI_WOL] ASC,
	[SHEET_CODE] ASC,
	[EMP_CODE] ASC,
	[ITEM_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가월' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'ESTI_WOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가 Sheet코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'SHEET_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담원ID' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가항목코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'ITEM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가점수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'ITEM_VALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가메모' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'ITEM_MEMO'
GO
