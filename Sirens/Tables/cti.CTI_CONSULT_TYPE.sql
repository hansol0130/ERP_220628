USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_CONSULT_TYPE](
	[CONSULT_TYPE_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CONSULT_SEQ] [char](14) NULL,
	[CONSULT_TYPE] [varchar](10) NULL,
	[ITEM_CODE] [varchar](30) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NULL,
 CONSTRAINT [PK_CTI_CONSULT_TYPE] PRIMARY KEY CLUSTERED 
(
	[CONSULT_TYPE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담구분SEQ' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_TYPE', @level2type=N'COLUMN',@level2name=N'CONSULT_TYPE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담등록SEQ' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_TYPE', @level2type=N'COLUMN',@level2name=N'CONSULT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담구분' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_TYPE', @level2type=N'COLUMN',@level2name=N'CONSULT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담아이템코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_TYPE', @level2type=N'COLUMN',@level2name=N'ITEM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록일시' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_TYPE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_CONSULT_TYPE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
