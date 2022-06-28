USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_SCH_MAP](
	[MASTER_CODE] [varchar](10) NOT NULL,
	[DAY_NUMBER] [int] NOT NULL,
	[MAP_SEQ] [int] NOT NULL,
	[CNT_CODE] [int] NULL,
	[FILE_CODE] [int] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[GPS_X1] [numeric](18, 10) NULL,
	[GPS_Y1] [numeric](18, 10) NULL,
	[GPS_X2] [numeric](18, 10) NULL,
	[GPS_Y2] [numeric](18, 10) NULL,
	[ZOOM_LEVEL] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[DAY_NUMBER] ASC,
	[MAP_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_SCH_MAP]  WITH CHECK ADD FOREIGN KEY([CNT_CODE])
REFERENCES [dbo].[INF_MASTER] ([CNT_CODE])
GO
ALTER TABLE [dbo].[PKG_MASTER_SCH_MAP]  WITH CHECK ADD FOREIGN KEY([FILE_CODE])
REFERENCES [dbo].[INF_FILE_MASTER] ([FILE_CODE])
GO
ALTER TABLE [dbo].[PKG_MASTER_SCH_MAP]  WITH CHECK ADD FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'DAY_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지도순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'MAP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'FILE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표X1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'GPS_X1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표Y1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'GPS_Y1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표X2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'GPS_X2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표Y2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'GPS_Y2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'줌레벨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP', @level2type=N'COLUMN',@level2name=N'ZOOM_LEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터일정_스테틱맵' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_MAP'
GO
