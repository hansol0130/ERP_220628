USE [SEND]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NVSERVERINFO](
	[HOST_NM] [varchar](250) NOT NULL,
	[PORT_NO] [varchar](5) NULL,
	[DRIVER_NM] [varchar](250) NULL,
	[DRIVER_DSN] [varchar](250) NULL,
	[DBUSER_ID] [varchar](30) NULL,
	[DBPASSWORD] [varchar](30) NULL,
	[OPENCLICK_PATH] [varchar](250) NULL,
	[SURVEY_PATH] [varchar](250) NULL,
	[LINK_PATH] [varchar](250) NULL,
	[HTMLMAKER_PATH] [varchar](250) NULL,
	[OPENIMAGE_PATH] [varchar](250) NULL,
	[DURATION_PATH] [varchar](250) NULL,
	[REJECT_PATH] [varchar](250) NULL,
	[SMTP_IP] [varchar](250) NULL,
	[SMTP_PORT] [varchar](5) NULL,
	[FULA_IP] [varchar](250) NULL,
	[FULA_PORT] [varchar](5) NULL,
	[FTP_YN] [char](1) NULL,
	[FTP_USER_ID] [varchar](30) NULL,
	[FTP_PASSWORD] [varchar](30) NULL,
	[LASTUPDATE_DT] [char](8) NULL,
	[EDITOR_ID] [varchar](15) NULL,
	[RET_DOMAIN] [varchar](100) NULL,
	[RETRY_CNT] [numeric](2, 0) NULL,
	[B4_SEND_APPROVE_YN] [char](1) NULL,
	[B4_SEND_VERIFY_YN] [char](1) NULL,
	[B4_REAL_SEND_TEST_SEND_YN] [char](1) NULL,
	[ASE_LINK_MERGE_PARAM] [varchar](500) NULL,
	[ASE_REJECT_MERGE_PARAM] [varchar](500) NULL,
	[ASE_OPEN_SCRIPTLET] [varchar](2000) NULL,
	[GROOVY_LINK_MERGE_PARAM] [varchar](500) NULL,
	[GROOVY_REJECT_MERGE_PARAM] [varchar](500) NULL,
	[GROOVY_OPEN_SCRIPTLET] [varchar](2000) NULL,
	[RESEND_INCLUDE_RETURNMAIL_YN] [char](1) NULL,
	[RESEND_INCLUDE_MAIL_KEY_YN] [char](1) NULL,
	[RESEND_ERROR_CD] [varchar](500) NULL,
	[FAX_RESEND_ERROR_CD] [varchar](500) NULL,
	[SMS_RESEND_ERROR_CD] [varchar](500) NULL,
	[ALTALK_RESEND_ERROR_CD] [varchar](500) NULL,
	[SPOOL_PRESERVE_PERIOD] [varchar](4) NULL,
	[LOG_PRESERVE_PERIOD] [varchar](4) NULL,
	[RESULT_FILE_DOWNLOAD_YN] [char](1) NULL,
	[SUCS_RESULT_FILE_DOWNLOAD_YN] [char](1) NULL,
	[KAKAO_TEMPLATE_LAST_SYNC_DTM] [varchar](14) NULL,
 CONSTRAINT [PK_NVSERVERINFO] PRIMARY KEY CLUSTERED 
(
	[HOST_NM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NVSERVERINFO] ADD  DEFAULT ('N') FOR [B4_SEND_APPROVE_YN]
GO
ALTER TABLE [dbo].[NVSERVERINFO] ADD  DEFAULT ('N') FOR [B4_SEND_VERIFY_YN]
GO
ALTER TABLE [dbo].[NVSERVERINFO] ADD  DEFAULT ('N') FOR [B4_REAL_SEND_TEST_SEND_YN]
GO
ALTER TABLE [dbo].[NVSERVERINFO] ADD  DEFAULT ('Y') FOR [RESEND_INCLUDE_RETURNMAIL_YN]
GO
ALTER TABLE [dbo].[NVSERVERINFO] ADD  DEFAULT ('Y') FOR [RESEND_INCLUDE_MAIL_KEY_YN]
GO
ALTER TABLE [dbo].[NVSERVERINFO] ADD  DEFAULT ('7') FOR [SPOOL_PRESERVE_PERIOD]
GO
ALTER TABLE [dbo].[NVSERVERINFO] ADD  DEFAULT ('Y') FOR [RESULT_FILE_DOWNLOAD_YN]
GO
ALTER TABLE [dbo].[NVSERVERINFO] ADD  DEFAULT ('N') FOR [SUCS_RESULT_FILE_DOWNLOAD_YN]
GO
