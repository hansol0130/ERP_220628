USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_AIR_RULE](
	[AGT_CODE] [varchar](10) NOT NULL,
	[BT_SEQ] [int] NOT NULL,
	[AIR_RULE_SEQ] [int] NOT NULL,
	[CLASS_NOT_USE] [char](1) NULL,
	[START_HOUR] [int] NULL,
	[END_HOUR] [int] NULL,
	[CLASS] [char](1) NULL,
	[USE_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_SEQ] [int] NULL,
 CONSTRAINT [PK_COM_AIR_RULE] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[BT_SEQ] ASC,
	[AIR_RULE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장그룹순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'BT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공규정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'AIR_RULE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용불가유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'CLASS_NOT_USE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기준시작시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'START_HOUR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기준만료시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'END_HOUR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석등급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE', @level2type=N'COLUMN',@level2name=N'NEW_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객사항공규정관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_AIR_RULE'
GO
