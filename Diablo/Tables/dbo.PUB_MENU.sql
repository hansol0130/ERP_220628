USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_MENU](
	[MENU_GROUP_CODE] [varchar](5) NOT NULL,
	[MENU_CODE] [int] NOT NULL,
	[MENU_NAME] [varchar](60) NOT NULL,
	[PARENT_CODE] [int] NULL,
	[SORT_CODE] [int] NULL,
	[SHOW_YN] [char](1) NULL,
	[REMARK] [varchar](50) NULL,
	[MENU_ORDER] [int] NULL,
	[MENU_LINK] [varchar](100) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_PUB_MENU] PRIMARY KEY CLUSTERED 
(
	[MENU_GROUP_CODE] ASC,
	[MENU_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'MENU_GROUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'MENU_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'MENU_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상위코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'PARENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'SORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴보기유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴정렬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'MENU_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'MENU_LINK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_MENU'
GO
