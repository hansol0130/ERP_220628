USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_CHANGE_DORMANT_MEMBER_TARGET](
	[CUS_NO] [int] NOT NULL,
	[CUS_NAME] [varchar](20) NOT NULL,
	[CUS_ID] [varchar](20) NULL,
	[TEL] [varchar](15) NULL,
	[LAST_LOGIN_DATE] [datetime] NULL,
 CONSTRAINT [PK_EVT_CHANGE_DORMANT_MEMBER_TARGET] PRIMARY KEY CLUSTERED 
(
	[CUS_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_CHANGE_DORMANT_MEMBER_TARGET', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_CHANGE_DORMANT_MEMBER_TARGET', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_CHANGE_DORMANT_MEMBER_TARGET', @level2type=N'COLUMN',@level2name=N'CUS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'휴대폰번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_CHANGE_DORMANT_MEMBER_TARGET', @level2type=N'COLUMN',@level2name=N'TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마지막로그인날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_CHANGE_DORMANT_MEMBER_TARGET', @level2type=N'COLUMN',@level2name=N'LAST_LOGIN_DATE'
GO
