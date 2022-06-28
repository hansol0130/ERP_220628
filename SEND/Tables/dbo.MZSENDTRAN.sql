USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MZSENDTRAN](
	[SN] [varchar](100) NOT NULL,
	[SENDER_KEY] [varchar](40) NOT NULL,
	[CHANNEL] [varchar](1) NOT NULL,
	[SND_TYPE] [varchar](1) NOT NULL,
	[PHONE_NUM] [varchar](16) NOT NULL,
	[TMPL_CD] [varchar](30) NOT NULL,
	[SUBJECT] [varchar](40) NULL,
	[SND_MSG] [nvarchar](1000) NOT NULL,
	[SMS_SND_MSG] [varchar](2000) NULL,
	[SMS_SND_NUM] [varchar](16) NULL,
	[REQ_DEPT_CD] [varchar](50) NOT NULL,
	[REQ_USR_ID] [varchar](50) NOT NULL,
	[REQ_DTM] [varchar](14) NOT NULL,
	[SND_DTM] [varchar](14) NULL,
	[RSLT_CD] [varchar](4) NULL,
	[RCPT_MSG] [varchar](250) NULL,
	[RCPT_DTM] [varchar](14) NULL,
	[SMS_SND_DTM] [varchar](14) NULL,
	[SMS_RSLT_CD] [varchar](4) NULL,
	[SMS_RCPT_MSG] [varchar](250) NULL,
	[SMS_RCPT_DTM] [varchar](14) NULL,
	[SMS_GB] [varchar](1) NULL,
	[SMS_SND_YN] [varchar](1) NULL,
	[TRAN_SN] [decimal](16, 0) NULL,
	[TRAN_STS] [varchar](1) NOT NULL,
	[AGENT_ID] [varchar](20) NULL,
	[SLOT1] [varchar](100) NULL,
	[SLOT2] [varchar](100) NULL,
	[TR_TYPE_CD] [varchar](1) NULL,
	[ATTACHMENT] [varchar](4000) NULL,
	[SERVICE_TYPE] [varchar](2) NULL,
	[SERVICE_NO] [varchar](15) NULL,
	[RESULT_SEQ] [varchar](16) NULL,
 CONSTRAINT [PK_MZSENDTRAN] PRIMARY KEY CLUSTERED 
(
	[SN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MZSENDTRAN] ADD  DEFAULT ('admin') FOR [REQ_DEPT_CD]
GO
ALTER TABLE [dbo].[MZSENDTRAN] ADD  DEFAULT ('admin') FOR [REQ_USR_ID]
GO
ALTER TABLE [dbo].[MZSENDTRAN] ADD  DEFAULT ('N') FOR [SMS_SND_YN]
GO
ALTER TABLE [dbo].[MZSENDTRAN] ADD  DEFAULT ('1') FOR [TRAN_STS]
GO
ALTER TABLE [dbo].[MZSENDTRAN] ADD  DEFAULT ('B') FOR [TR_TYPE_CD]
GO
ALTER TABLE [dbo].[MZSENDTRAN] ADD  DEFAULT ('ec') FOR [SERVICE_TYPE]
GO
ALTER TABLE [dbo].[MZSENDTRAN] ADD  DEFAULT ('3') FOR [SERVICE_NO]
GO
ALTER TABLE [dbo].[MZSENDTRAN] ADD  DEFAULT (CONVERT([varchar](8),getdate(),(112))) FOR [RESULT_SEQ]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송프로필키' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SENDER_KEY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'채널' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'CHANNEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알림톡발송방식. P:푸시, R:실시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신자휴대폰번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'PHONE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알림톡탬플릿코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'TMPL_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LMS제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송메시지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SND_MSG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS발송메시지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SMS_SND_MSG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS발신번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SMS_SND_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송요청부서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'REQ_DEPT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송요청자ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'REQ_USR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송요청일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'REQ_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agent 발송일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SND_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알림톡처리결과코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'RSLT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알림톡처리결과메시지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'RCPT_MSG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agent 수신일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'RCPT_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS발송일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SMS_SND_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS처리결과코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SMS_RSLT_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS처리메시지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SMS_RCPT_MSG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS수신일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SMS_RCPT_DTM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS 구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SMS_GB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS 발송여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SMS_SND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'TRAN_SN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'TRAN_STS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agent 서버 식별자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'AGENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송요청부가정보1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SLOT1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송요청부가정보2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'SLOT2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송유형. B:배치, R:실시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'TR_TYPE_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'링크 버튼 JSON' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN', @level2type=N'COLUMN',@level2name=N'ATTACHMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'엠지기발송트랜젝션' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MZSENDTRAN'
GO
