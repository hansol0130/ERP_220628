USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_CUS_ESTI_SHEET](
	[SHEET_CODE] [int] IDENTITY(1,1) NOT NULL,
	[TITLE] [varchar](100) NOT NULL,
	[MODIFY_FLAG] [char](1) NOT NULL,
	[USE_YN] [char](1) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
 CONSTRAINT [PK_CTI_CUS_ESTI_SHEET] PRIMARY KEY CLUSTERED 
(
	[SHEET_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [cti].[CTI_CUS_ESTI_SHEET] ADD  CONSTRAINT [DF_CTI_CUS_ESTI_SHEET_USE_YN]  DEFAULT ('N') FOR [USE_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가 Sheet코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_SHEET', @level2type=N'COLUMN',@level2name=N'SHEET_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가 Sheet명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_SHEET', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정가능' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_SHEET', @level2type=N'COLUMN',@level2name=N'MODIFY_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_SHEET', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_SHEET', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_SHEET', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정작업자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CUS_ESTI_SHEET', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
