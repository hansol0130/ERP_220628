USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[SCH_SEQ] [int] NOT NULL,
	[DAY_SEQ] [int] NOT NULL,
	[DAY_NUMBER] [int] NULL,
	[TRANSPORT_SEQ] [int] NOT NULL,
	[TRANSPORT_TYPE] [varchar](10) NULL,
	[TRANSPORT_DESC] [varchar](100) NULL,
 CONSTRAINT [PK_NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[SCH_SEQ] ASC,
	[DAY_SEQ] ASC,
	[TRANSPORT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT', @level2type=N'COLUMN',@level2name=N'SCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT', @level2type=N'COLUMN',@level2name=N'DAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT', @level2type=N'COLUMN',@level2name=N'DAY_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이동수단순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT', @level2type=N'COLUMN',@level2name=N'TRANSPORT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이동수단타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT', @level2type=N'COLUMN',@level2name=N'TRANSPORT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이동수단설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT', @level2type=N'COLUMN',@level2name=N'TRANSPORT_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'네이버자상품일정별이동수단' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_SCH_DAY_TRANSPORT'
GO
