USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_TEAM](
	[AGT_CODE] [varchar](10) NOT NULL,
	[TEAM_SEQ] [int] NOT NULL,
	[TEAM_NAME] [varchar](40) NULL,
	[COM_NUMBER] [varchar](20) NULL,
	[PARENT_TEAM_SEQ] [int] NULL,
	[ORDER_NUM] [int] NULL,
	[USE_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_SEQ] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_SEQ] [int] NULL,
 CONSTRAINT [PK_COM_TEAM] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[TEAM_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'TEAM_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부서명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부서전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'COM_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상위부서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'PARENT_TEAM_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'ORDER_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'NEW_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM', @level2type=N'COLUMN',@level2name=N'EDT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객사부서정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_TEAM'
GO
