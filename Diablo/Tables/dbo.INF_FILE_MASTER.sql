USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_FILE_MASTER](
	[FILE_CODE] [int] NOT NULL,
	[REGION_CODE] [dbo].[REGION_CODE] NULL,
	[NATION_CODE] [dbo].[NATION_CODE] NULL,
	[STATE_CODE] [dbo].[STATE_CODE] NULL,
	[CITY_CODE] [dbo].[CITY_CODE] NULL,
	[KOR_NAME] [nvarchar](100) NULL,
	[ENG_NAME] [varchar](100) NULL,
	[FILE_TYPE] [int] NULL,
	[FILE_NAME] [nvarchar](100) NULL,
	[EXTENSION_NAME] [varchar](10) NULL,
	[FILE_SIZE] [int] NULL,
	[FILE_NAME_S] [nvarchar](100) NULL,
	[FILE_NAME_M] [nvarchar](100) NULL,
	[FILE_NAME_L] [nvarchar](100) NULL,
	[FILE_REMARK] [nvarchar](1000) NULL,
	[FILE_TAG] [nvarchar](100) NULL,
	[RESOLUTION] [varchar](20) NULL,
	[COPYRIGHT] [char](1) NULL,
	[COPYRIGHT_REMARK] [varchar](100) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[FILE_NAME_W] [nvarchar](100) NULL,
 CONSTRAINT [PK_INF_FILE_MASTER] PRIMARY KEY CLUSTERED 
(
	[FILE_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'STATE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한글명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'ENG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : (None, 이미지), 9 : (동영상, 문서, 고정맵)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확장자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'EXTENSION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일크기' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_SIZE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_NAME_S'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명중' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_NAME_M'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_NAME_L'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일태그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_TAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'해상도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'RESOLUTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'저작권타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'COPYRIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'저작권내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'COPYRIGHT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'노출여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'와이드이미지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER', @level2type=N'COLUMN',@level2name=N'FILE_NAME_W'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MASTER'
GO
