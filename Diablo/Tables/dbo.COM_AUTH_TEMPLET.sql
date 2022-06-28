USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_AUTH_TEMPLET](
	[AGT_CODE] [varchar](10) NOT NULL,
	[MENU_SEQ] [int] NOT NULL,
 CONSTRAINT [PK_COM_AUTH_TEMPLET] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[MENU_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AUTH_TEMPLET', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AUTH_TEMPLET', @level2type=N'COLUMN',@level2name=N'MENU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹권한관리템플릿' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AUTH_TEMPLET'
GO
