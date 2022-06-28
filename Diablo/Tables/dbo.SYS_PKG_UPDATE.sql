USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYS_PKG_UPDATE](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[BASE_MASTER_CODE] [varchar](8000) NULL,
	[PRICE] [int] NULL,
	[PRICE_RATE] [decimal](6, 2) NULL,
	[AGE_TYPE] [varchar](3) NULL,
	[MAX_COUNT] [int] NULL,
	[MIN_COUNT] [int] NULL,
	[RES_ADD_YN] [char](1) NULL,
	[START] [varchar](10) NULL,
	[END] [varchar](10) NULL,
	[WEEK_DAY_TYPE] [varchar](7) NULL,
	[DAYS] [varchar](1000) NULL,
	[UPDATE_TYPE] [varchar](10) NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
	[NEW_DATE] [datetime] NULL,
	[AIRLINE_CODE] [varchar](2) NULL,
	[AIRLINE_NUMBER] [varchar](4) NULL,
	[FAKE_COUNT] [int] NULL,
	[POINT_YN] [char](1) NULL,
 CONSTRAINT [PK_SYS_PKG_UPDATE] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'BASE_MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정가격' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'PRICE_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'나이타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'AGE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최대인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'MAX_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최소인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'MIN_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약가능여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'RES_ADD_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정시작' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'START'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정끝' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'END'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요일패턴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'WEEK_DAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'DAYS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'UPDATE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공편' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE', @level2type=N'COLUMN',@level2name=N'AIRLINE_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사일괄수정로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYS_PKG_UPDATE'
GO
