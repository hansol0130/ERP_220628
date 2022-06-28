USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_VGT_MENU](
	[MENU_CODE] [varchar](20) NOT NULL,
	[PARENT_CODE] [varchar](20) NULL,
	[MENU_NAME] [varchar](100) NULL,
	[REGION_CODE] [varchar](30) NULL,
	[CITY_CODE] [varchar](30) NULL,
	[NATION_CODE] [varchar](30) NULL,
	[ATT_CODE] [varchar](50) NULL,
	[GROUP_CODE] [varchar](100) NULL,
	[BASIC_CODE] [varchar](20) NULL,
	[CATEGORY_TYPE] [varchar](1) NULL,
	[VIEW_TYPE] [varchar](1) NULL,
	[LINK_URL] [varchar](200) NULL,
	[IMAGE_URL] [varchar](200) NULL,
	[ORDER_TYPE] [int] NULL,
	[BEST_CODE] [varchar](50) NULL,
	[FONT_STYLE] [varchar](30) NULL,
	[FONT_COLOR] [varchar](10) NULL,
	[ORDER_NUM] [int] NULL,
	[USE_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[OLD_MENU_CODE] [varchar](2) NULL,
 CONSTRAINT [PK_PUB_VGT_MENU] PRIMARY KEY CLUSTERED 
(
	[MENU_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'MENU_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부모코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'PARENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'MENU_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'속성코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'ATT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'GROUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베이직코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'BASIC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'CATEGORY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품보기타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'VIEW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직접링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'LINK_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이미지링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'IMAGE_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬(1 : 지역별, 2 : 테마별, 3: 그룹별)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'ORDER_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자강력추천' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'BEST_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'글자타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'FONT_STYLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'글자색' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'FONT_COLOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'ORDER_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전메뉴코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU', @level2type=N'COLUMN',@level2name=N'OLD_MENU_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'홈페이지메뉴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_VGT_MENU'
GO
