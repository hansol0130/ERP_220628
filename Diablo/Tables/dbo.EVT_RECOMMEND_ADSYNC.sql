USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_RECOMMEND_ADSYNC](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NULL,
	[UID_NUM] [varchar](100) NULL,
	[AD_NO] [varchar](100) NULL,
	[REWARD_KEY] [varchar](100) NULL,
	[NEW_DATE] [datetime] NOT NULL,
 CONSTRAINT [PK_EVT_RECOMMEND_ADSYNC] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EVT_RECOMMEND_ADSYNC] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매체회원키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC', @level2type=N'COLUMN',@level2name=N'UID_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'광고번호키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC', @level2type=N'COLUMN',@level2name=N'AD_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리워드키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC', @level2type=N'COLUMN',@level2name=N'REWARD_KEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_RECOMMEND_ADSYNC', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
