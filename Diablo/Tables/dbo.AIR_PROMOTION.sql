USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AIR_PROMOTION](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[TITLE] [varchar](100) NOT NULL,
	[AIRLINE_CODE] [char](2) NOT NULL,
	[AIRPORT_CODE] [varchar](500) NOT NULL,
	[CLASS] [varchar](500) NULL,
	[SDATE] [datetime] NOT NULL,
	[EDATE] [datetime] NOT NULL,
	[DEP_SDATE] [datetime] NOT NULL,
	[DEP_EDATE] [datetime] NOT NULL,
	[SALE_PRICE] [int] NULL,
	[SALE_COMM_RATE] [decimal](18, 2) NULL,
	[USE_YN] [char](1) NULL,
	[SITE_CODE] [varchar](50) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[LIMITED_DATE] [varchar](500) NULL,
	[MIN_PAX_COUNT] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIR_PROMOTION] ADD  DEFAULT ('N') FOR [USE_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로모션할인코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로모션명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌성등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로모션시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'SDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로모션종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'EDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'DEP_SDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'귀국일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'DEP_EDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'SALE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'SALE_COMM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사이트코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'SITE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인제외일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'LIMITED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최소출발인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION', @level2type=N'COLUMN',@level2name=N'MIN_PAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'AIR_PROMOTION' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIR_PROMOTION'
GO
