USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAFE_INFO_COUNTRY_NOTICE](
	[ID] [varchar](20) NOT NULL,
	[NATION_CODE] [varchar](3) NULL,
	[TITLE] [varchar](300) NULL,
	[CONTENTS_HTML] [varchar](max) NULL,
	[CONTENTS] [varchar](max) NULL,
	[FILE_URL] [varchar](100) NULL,
	[WRT_DT] [datetimeoffset](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[SHOW_COUNT] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SAFE_INFO_COUNTRY_NOTICE] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고유값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용(HTML)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'CONTENTS_HTML'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용(TEXT)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'첨부파일경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'FILE_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'WRT_DT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조회수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE', @level2type=N'COLUMN',@level2name=N'SHOW_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가안내정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAFE_INFO_COUNTRY_NOTICE'
GO
