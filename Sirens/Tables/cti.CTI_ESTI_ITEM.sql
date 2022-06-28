USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_ESTI_ITEM](
	[SHEET_CODE] [int] NOT NULL,
	[ITEM_CODE] [char](4) NOT NULL,
	[ITEM_NAME] [nvarchar](100) NOT NULL,
	[ITEM_LEVEL] [int] NOT NULL,
	[VALUE_MIN] [int] NOT NULL,
	[VALUE_MAX] [int] NOT NULL,
	[MEMO] [nvarchar](1000) NULL,
 CONSTRAINT [PK_CTI_ESTI_ITEM] PRIMARY KEY CLUSTERED 
(
	[SHEET_CODE] ASC,
	[ITEM_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가 Sheet코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_ITEM', @level2type=N'COLUMN',@level2name=N'SHEET_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가항목코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_ITEM', @level2type=N'COLUMN',@level2name=N'ITEM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가항목명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_ITEM', @level2type=N'COLUMN',@level2name=N'ITEM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'단계' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_ITEM', @level2type=N'COLUMN',@level2name=N'ITEM_LEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최소값' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_ITEM', @level2type=N'COLUMN',@level2name=N'VALUE_MIN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대값' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_ITEM', @level2type=N'COLUMN',@level2name=N'VALUE_MAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메모' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_ESTI_ITEM', @level2type=N'COLUMN',@level2name=N'MEMO'
GO
