USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAFE_INFO_ACCIDENT](
	[ID] [varchar](20) NOT NULL,
	[CONTINENT] [varchar](60) NULL,
	[COUNTRY_NAME] [varchar](50) NULL,
	[COUNTRY_EN_NAME] [varchar](50) NULL,
	[NEWS] [varchar](max) NULL,
	[IMG_URL1] [varchar](100) NULL,
	[IMG_URL2] [varchar](100) NULL,
	[WRT_DT] [datetime] NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SAFE_INFO_ACCIDENT] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고유값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대륙' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'CONTINENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'COUNTRY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'COUNTRY_EN_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사건사고현황' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'NEWS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국기이미지경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'IMG_URL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행위험지도경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'IMG_URL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'WRT_DT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사건사고현황' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_ACCIDENT'
GO
