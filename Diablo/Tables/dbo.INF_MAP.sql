USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_MAP](
	[CNT_CODE] [int] NOT NULL,
	[GPS_X1] [numeric](18, 10) NULL,
	[GPS_Y1] [numeric](18, 10) NULL,
	[GPS_X2] [numeric](18, 10) NULL,
	[GPS_Y2] [numeric](18, 10) NULL,
	[ZOOM_LEVEL] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_MAP]  WITH CHECK ADD FOREIGN KEY([CNT_CODE])
REFERENCES [dbo].[INF_MASTER] ([CNT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MAP', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표X1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MAP', @level2type=N'COLUMN',@level2name=N'GPS_X1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표Y1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MAP', @level2type=N'COLUMN',@level2name=N'GPS_Y1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표X2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MAP', @level2type=N'COLUMN',@level2name=N'GPS_X2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌표Y2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MAP', @level2type=N'COLUMN',@level2name=N'GPS_Y2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'줌레벨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MAP', @level2type=N'COLUMN',@level2name=N'ZOOM_LEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지도컨텐츠' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_MAP'
GO
