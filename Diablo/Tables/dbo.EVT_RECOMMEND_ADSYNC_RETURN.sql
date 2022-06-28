USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_RECOMMEND_ADSYNC_RETURN](
	[SEQ] [int] NOT NULL,
	[CUS_NO] [int] NOT NULL,
	[CUS_NO_RECOM] [int] NOT NULL,
	[URL_VALUE] [varchar](1000) NOT NULL,
	[RETURN_VALUE] [varchar](1000) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EVT_RECOMMEND_ADSYNC_RETURN] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC_RETURN', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC_RETURN', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추천고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC_RETURN', @level2type=N'COLUMN',@level2name=N'CUS_NO_RECOM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC_RETURN', @level2type=N'COLUMN',@level2name=N'URL_VALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리턴값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC_RETURN', @level2type=N'COLUMN',@level2name=N'RETURN_VALUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC_RETURN', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
