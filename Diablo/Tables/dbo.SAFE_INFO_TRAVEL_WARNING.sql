USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAFE_INFO_TRAVEL_WARNING](
	[ID] [varchar](20) NOT NULL,
	[CONTINENT] [varchar](60) NULL,
	[COUNTRY_NAME] [varchar](50) NULL,
	[COUNTRY_EN_NAME] [varchar](50) NULL,
	[IMG_URL1] [varchar](100) NULL,
	[IMG_URL2] [varchar](100) NULL,
	[ATTENTION] [varchar](20) NULL,
	[ATTENTION_PARTIAL] [varchar](20) NULL,
	[ATTENTION_NOTE] [varchar](500) NULL,
	[CONTROL] [varchar](20) NULL,
	[CONTROL_PARTIAL] [varchar](20) NULL,
	[CONTROL_NOTE] [varchar](500) NULL,
	[LIMITA] [varchar](20) NULL,
	[LIMITA_PARTIAL] [varchar](20) NULL,
	[LIMITA_NOTE] [varchar](500) NULL,
	[WRT_DT] [datetime] NULL,
	[NEW_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SAFE_INFO_TRAVEL_WARNING] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고유값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대륙' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'CONTINENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'COUNTRY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문국가명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'COUNTRY_EN_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국기이미지경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'IMG_URL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행위험지도경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'IMG_URL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행유의' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'ATTENTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행유의(일부)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'ATTENTION_PARTIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행유의내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'ATTENTION_NOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자제' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'CONTROL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자제(일부)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'CONTROL_PARTIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자제내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'CONTROL_NOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행제한' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'LIMITA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행제한(일부)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'LIMITA_PARTIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행제한내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'LIMITA_NOTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'WRT_DT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행경보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_TRAVEL_WARNING'
GO
