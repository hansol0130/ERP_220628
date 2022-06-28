USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_EVENT_COUNT](
	[FLAG] [char](1) NULL,
	[DATA] [varchar](10) NULL,
	[COUNT] [int] NULL,
	[PROVIDER] [varchar](20) NULL,
	[DATA_NAME] [varchar](30) NULL,
	[PROVIDER_NAME] [varchar](30) NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_COUNT', @level2type=N'COLUMN',@level2name=N'FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세부구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_COUNT', @level2type=N'COLUMN',@level2name=N'DATA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_COUNT', @level2type=N'COLUMN',@level2name=N'COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유입코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_COUNT', @level2type=N'COLUMN',@level2name=N'PROVIDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_COUNT', @level2type=N'COLUMN',@level2name=N'DATA_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유입처명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_COUNT', @level2type=N'COLUMN',@level2name=N'PROVIDER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트항목수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_COUNT'
GO
