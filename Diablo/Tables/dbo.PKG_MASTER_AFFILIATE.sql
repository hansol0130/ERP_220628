USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_AFFILIATE](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[AFF_TYPE] [int] NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[USE_YN] [char](1) NULL,
	[EDT_CODE] [dbo].[NEW_CODE] NULL,
	[EDT_DATE] [datetime] NULL,
	[PROVIDER] [int] NULL,
	[AFF_CATE_CODE] [varchar](20) NULL,
	[AFF_CATE_NAME] [varchar](100) NULL,
	[AFF_REMARK] [varchar](500) NULL,
	[BIT_CODE] [varchar](4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_AFFILIATE] ADD  DEFAULT ('') FOR [BIT_CODE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AFFILIATE', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전체 = 0, G마켓 = 1, 신한카드 = 2, 롯데카드 = 3, 다음쇼핑 = 4, 네이버 = 5, 현대카드 = 6, 십일번가 = 7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_AFFILIATE', @level2type=N'COLUMN',@level2name=N'AFF_TYPE'
GO
