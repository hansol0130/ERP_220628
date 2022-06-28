USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_SNS_INFO](
	[CUS_NO] [int] NOT NULL,
	[SNS_COMPANY] [int] NOT NULL,
	[SNS_ID] [varchar](100) NOT NULL,
	[SNS_EMAIL] [varchar](100) NULL,
	[SNS_NAME] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
	[DISCNT_DATE] [datetime] NULL,
	[INFLOW_TYPE] [int] NULL,
	[CHANGE_DATE] [datetime] NULL,
	[CREATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_CUS_SNS_INFO] PRIMARY KEY CLUSTERED 
(
	[SNS_COMPANY] ASC,
	[SNS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_SNS_INFO] ADD  DEFAULT (getdate()) FOR [CREATE_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정회원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 페이스북, 2 카카오톡, 3 네이버, 4 카카오싱크 5.애플' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'SNS_COMPANY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SNS_아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'SNS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SNS_이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'SNS_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'닉네임' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'SNS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연결일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'해제일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'DISCNT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유입경로-1 신규가입 고객, 2 전환 고객, 10 이후 마케팅/CS지원팀 사용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'INFLOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전환일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'CHANGE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_SNS_INFO', @level2type=N'COLUMN',@level2name=N'CREATE_DATE'
GO
