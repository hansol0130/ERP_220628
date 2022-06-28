USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_MENU](
	[MENU_SEQ] [int] NOT NULL,
	[MENU_NAME] [varchar](40) NULL,
	[MENU_URL] [varchar](100) NULL,
	[PARENT_MENU_SEQ] [int] NULL,
	[ORDER_NUM] [int] NULL,
	[USE_YN] [char](1) NULL,
 CONSTRAINT [PK_COM_MENU] PRIMARY KEY CLUSTERED 
(
	[MENU_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MENU', @level2type=N'COLUMN',@level2name=N'MENU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MENU', @level2type=N'COLUMN',@level2name=N'MENU_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MENU', @level2type=N'COLUMN',@level2name=N'MENU_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상위메뉴코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MENU', @level2type=N'COLUMN',@level2name=N'PARENT_MENU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MENU', @level2type=N'COLUMN',@level2name=N'ORDER_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MENU', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_MENU'
GO
