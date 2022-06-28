USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_RES_MESSAGE](
	[RES_SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[MSG_TYPE] [int] NULL,
	[MSG_METHOD] [int] NULL,
	[BASIC_ITEM] [int] NULL,
	[TITLE] [varchar](100) NULL,
	[REMARK] [varchar](2000) NULL,
	[PRO_CODE] [varchar](100) NULL,
	[RES_CODE] [varchar](200) NULL,
	[APP_TARGET] [int] NULL,
	[RESERVE_TIME] [datetime] NULL,
	[WAIT_DAY] [int] NULL,
	[WAIT_HOUR] [int] NULL,
	[WAIT_MINUTE] [int] NULL,
	[WAIT_BA] [char](1) NULL,
	[SEND_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[MSG_PATH] [varchar](200) NULL,
 CONSTRAINT [PK_APP_RES_MESSAGE] PRIMARY KEY CLUSTERED 
(
	[RES_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'RES_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: 이벤트, 2: 광고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'MSG_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: 즉시발송, 2 : 예약발송, 3 : 자동발송' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'MSG_METHOD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 예약일, 2 : 출발일, 3 : 도착일, 4 : 회원가입일, 5 : 생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'BASIC_ITEM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송대상' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'APP_TARGET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예정시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'RESERVE_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대기일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'WAIT_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대기시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'WAIT_HOUR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대기분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'WAIT_MINUTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이전이후' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'WAIT_BA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'SEND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메세지파일위치' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE', @level2type=N'COLUMN',@level2name=N'MSG_PATH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객알림예약' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RES_MESSAGE'
GO
