USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_HTL_LINK_LOG](
	[LINK_NO] [int] IDENTITY(1,1) NOT NULL,
	[RESV_NO] [int] NOT NULL,
	[RES_CODE] [varchar](20) NULL,
	[SYNC_TYPE] [varchar](20) NULL,
	[IN_DATE] [datetime] NULL,
	[OUT_DATE] [datetime] NULL,
	[AUTO_YN] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[LINK_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_HTL_LINK_LOG] ADD  CONSTRAINT [DF_RES_HTL_LINK_LOG_IN_DATE]  DEFAULT (getdate()) FOR [IN_DATE]
GO
ALTER TABLE [dbo].[RES_HTL_LINK_LOG] ADD  CONSTRAINT [DF_RES_HTL_LINK_LOG_AUTO_YN]  DEFAULT ('Y') FOR [AUTO_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LINK 일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_LINK_LOG', @level2type=N'COLUMN',@level2name=N'LINK_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SUP 예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_LINK_LOG', @level2type=N'COLUMN',@level2name=N'RESV_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_LINK_LOG', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SYNC 타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_LINK_LOG', @level2type=N'COLUMN',@level2name=N'SYNC_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IN 일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_LINK_LOG', @level2type=N'COLUMN',@level2name=N'IN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'OUT 일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_LINK_LOG', @level2type=N'COLUMN',@level2name=N'OUT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자동/수동 유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_LINK_LOG', @level2type=N'COLUMN',@level2name=N'AUTO_YN'
GO
