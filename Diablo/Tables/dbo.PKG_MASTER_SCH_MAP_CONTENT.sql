USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_SCH_MAP_CONTENT](
	[MASTER_CODE] [varchar](10) NOT NULL,
	[DAY_NUMBER] [int] NOT NULL,
	[MAP_SEQ] [int] NOT NULL,
	[CNT_ORDER] [int] NOT NULL,
	[CNT_CODE] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[DAY_NUMBER] ASC,
	[MAP_SEQ] ASC,
	[CNT_ORDER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_SCH_MAP_CONTENT]  WITH CHECK ADD FOREIGN KEY([MASTER_CODE], [DAY_NUMBER], [MAP_SEQ])
REFERENCES [dbo].[PKG_MASTER_SCH_MAP] ([MASTER_CODE], [DAY_NUMBER], [MAP_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP_CONTENT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP_CONTENT', @level2type=N'COLUMN',@level2name=N'DAY_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지도순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP_CONTENT', @level2type=N'COLUMN',@level2name=N'MAP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP_CONTENT', @level2type=N'COLUMN',@level2name=N'CNT_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP_CONTENT', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터일정_스테틱맵_컨텐츠' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP_CONTENT'
GO
