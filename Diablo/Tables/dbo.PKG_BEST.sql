USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_BEST](
	[BASIS_DAY] [varchar](10) NOT NULL,
	[BEST_SEQ] [int] NOT NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[RES_COUNT] [int] NULL,
	[LAST_WEEK] [int] NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_PKG_BEST] PRIMARY KEY CLUSTERED 
(
	[BASIS_DAY] ASC,
	[BEST_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기준일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_BEST', @level2type=N'COLUMN',@level2name=N'BASIS_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_BEST', @level2type=N'COLUMN',@level2name=N'BEST_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_BEST', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_BEST', @level2type=N'COLUMN',@level2name=N'RES_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지난주순위' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_BEST', @level2type=N'COLUMN',@level2name=N'LAST_WEEK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_BEST', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사베스트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_BEST'
GO
