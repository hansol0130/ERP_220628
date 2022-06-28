USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_SURVEY](
	[CUS_NO] [int] NOT NULL,
	[ORDER_BY] [char](2) NOT NULL,
	[REGION_CODE] [char](2) NOT NULL,
	[DAY] [char](2) NOT NULL,
	[PRICE] [char](2) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_DATE] [datetime] NULL,
 CONSTRAINT [PK_EVT_SURVEY] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SURVEY', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'누구와' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SURVEY', @level2type=N'COLUMN',@level2name=N'ORDER_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'어디로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SURVEY', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SURVEY', @level2type=N'COLUMN',@level2name=N'DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예산' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SURVEY', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SURVEY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_SURVEY', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
