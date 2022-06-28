USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMP_TEAM_ACC_damo](
	[ACC_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[TEAM_CODE] [char](3) NOT NULL,
	[ACC_NAME] [varchar](1000) NULL,
	[ACC_HOLDER] [varchar](40) NULL,
	[BANK_NAME] [varchar](40) NULL,
	[SORT_NUM] [int] NULL,
	[NEW_CODE] [char](7) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[EDT_DATE] [datetime] NULL,
	[DEL_YN] [char](1) NULL,
	[sec_ACC_NUM] [varbinary](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[ACC_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMP_TEAM_ACC_damo] ADD  DEFAULT ((0)) FOR [SORT_NUM]
GO
ALTER TABLE [dbo].[EMP_TEAM_ACC_damo] ADD  DEFAULT ('N') FOR [DEL_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'ACC_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'ACC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예금주' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'ACC_HOLDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'은행명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'BANK_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'SORT_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌번호_암호화필드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo', @level2type=N'COLUMN',@level2name=N'sec_ACC_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀계좌관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_TEAM_ACC_damo'
GO
