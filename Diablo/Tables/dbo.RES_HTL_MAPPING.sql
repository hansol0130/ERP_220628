USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_HTL_MAPPING](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[SUP_RES_CODE] [varchar](20) NULL,
	[SUP_CODE] [varchar](10) NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_RES_HTL_MAPPING] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VGT 예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_MAPPING', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급사 예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_MAPPING', @level2type=N'COLUMN',@level2name=N'SUP_RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급사 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_MAPPING', @level2type=N'COLUMN',@level2name=N'SUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자사번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_MAPPING', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_MAPPING', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
