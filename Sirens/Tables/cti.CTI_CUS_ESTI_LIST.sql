USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_CUS_ESTI_LIST](
	[ESTI_WOL] [char](6) NOT NULL,
	[SHEET_CODE] [int] NOT NULL,
	[CUS_NO] [int] NOT NULL,
	[ITEM_CODE] [char](4) NOT NULL,
	[SELECT_ITEM_CODE] [char](4) NOT NULL,
 CONSTRAINT [PK_CTI_CUS_ESTI_LIST] PRIMARY KEY CLUSTERED 
(
	[ESTI_WOL] ASC,
	[SHEET_CODE] ASC,
	[CUS_NO] ASC,
	[ITEM_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가월' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'ESTI_WOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가 Sheet코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'SHEET_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담등록ID' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가항목코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'ITEM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가점수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_LIST', @level2type=N'COLUMN',@level2name=N'SELECT_ITEM_CODE'
GO
