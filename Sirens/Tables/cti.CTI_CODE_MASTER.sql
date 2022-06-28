USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_CODE_MASTER](
	[CATEGORY] [char](6) NOT NULL,
	[CATEGORY_NAME] [varchar](50) NULL,
	[MAIN_CODE] [varchar](20) NOT NULL,
	[MAIN_NAME] [varchar](50) NULL,
	[REFERENCE_CATEGORY] [varchar](6) NULL,
	[REFERENCE_CODE] [varchar](20) NULL,
	[SORT] [smallint] NULL,
	[USE_YN] [char](1) NOT NULL,
	[REMARK] [nvarchar](200) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
 CONSTRAINT [PK_CTI_CODE_MASTER] PRIMARY KEY CLUSTERED 
(
	[CATEGORY] ASC,
	[MAIN_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드 카테고리' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'CATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'CATEGORY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'MAIN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'코드명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'MAIN_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관련1(카테고리)' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'REFERENCE_CATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관련2(코드)' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'REFERENCE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'SORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정작업자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CODE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
