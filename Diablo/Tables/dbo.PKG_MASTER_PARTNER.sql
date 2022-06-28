USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_PARTNER](
	[MASTER_CODE] [varchar](10) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[ALONE] [int] NULL,
	[FRIEND] [int] NULL,
	[FAMILY] [int] NULL,
	[COUPLE] [int] NULL,
	[MEETING] [int] NULL,
	[ETC] [int] NULL,
	[ALONE_PERCENT] [int] NULL,
	[FRIEND_PERCENT] [int] NULL,
	[FAMILY_PERCENT] [int] NULL,
	[COUPLE_PERCENT] [int] NULL,
	[MEETING_PERCENT] [int] NULL,
	[ETC_PERCENT] [int] NULL,
	[TOTAL_COUNT] [int] NULL,
	[STAR_POINT] [decimal](18, 0) NULL,
	[STAR_COUNT] [int] NULL,
 CONSTRAINT [PK_PKG_MASTER_PARTNER] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_PARTNER] ADD  CONSTRAINT [DEF_PKG_MASTER_PARTNER_STAR_POINT]  DEFAULT ((0)) FOR [STAR_POINT]
GO
ALTER TABLE [dbo].[PKG_MASTER_PARTNER] ADD  CONSTRAINT [DEF_PKG_MASTER_PARTNER_STAR_COUNT]  DEFAULT ((0)) FOR [STAR_COUNT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'통계일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'혼자출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'ALONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'친구와출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'FRIEND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가족과출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'FAMILY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'커플출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'COUPLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모임출발여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'MEETING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'나머지여행' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'ETC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'혼자출발여행퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'ALONE_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'친구와출발여행퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'FRIEND_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가족과출발여행퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'FAMILY_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'커플출발여행퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'COUPLE_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모임출발여행퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'MEETING_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'나머지여행퍼센트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'ETC_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총여행수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER', @level2type=N'COLUMN',@level2name=N'TOTAL_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터별동반자분석통계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_PARTNER'
GO
