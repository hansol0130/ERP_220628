USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAFE_INFO_COUNTRY_BASIC](
	[ID] [varchar](20) NOT NULL,
	[CONTINENT] [varchar](60) NULL,
	[COUNTRY_NAME] [varchar](50) NULL,
	[COUNTRY_EN_NAME] [varchar](50) NULL,
	[BASIC_INFO] [varchar](5000) NULL,
	[IMG_URL] [varchar](100) NULL,
	[WRT_DT] [datetime] NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SAFE_INFO_COUNTRY_BASIC] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고유값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대륙' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC', @level2type=N'COLUMN',@level2name=N'CONTINENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC', @level2type=N'COLUMN',@level2name=N'COUNTRY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC', @level2type=N'COLUMN',@level2name=N'COUNTRY_EN_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기본정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC', @level2type=N'COLUMN',@level2name=N'BASIC_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국기이미지경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC', @level2type=N'COLUMN',@level2name=N'IMG_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC', @level2type=N'COLUMN',@level2name=N'WRT_DT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가기본정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_BASIC'
GO
