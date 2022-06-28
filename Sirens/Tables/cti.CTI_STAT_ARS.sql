USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_STAT_ARS](
	[S_DATE] [varchar](8) NOT NULL,
	[S_HOUR] [varchar](2) NOT NULL,
	[S_WEEK] [char](1) NULL,
	[GROUP_NO] [varchar](3) NOT NULL,
	[GROUP_NAME] [nvarchar](50) NULL,
	[TOTAL_CALL] [int] NULL,
	[DAN_CALL] [int] NULL,
	[REQ_CALL] [int] NULL,
	[CON_CALL] [int] NULL,
	[AB_CALL] [int] NULL,
	[CB_CALL] [int] NULL,
	[SMS_CALL] [int] NULL,
	[PMS_CNT] [int] NULL,
	[REG_CNT] [int] NULL,
	[FIN_CALL] [int] NULL,
 CONSTRAINT [PK_CTI_STAT_ARS] PRIMARY KEY CLUSTERED 
(
	[S_DATE] ASC,
	[S_HOUR] ASC,
	[GROUP_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [cti].[CTI_STAT_ARS] ADD  CONSTRAINT [DF_CTI_STAT_ARS_TOTAL_CALL]  DEFAULT ((0)) FOR [TOTAL_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_ARS] ADD  CONSTRAINT [DF_CTI_STAT_ARS_DAN_CALL]  DEFAULT ((0)) FOR [DAN_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_ARS] ADD  CONSTRAINT [DF_CTI_STAT_ARS_REQ_CALL]  DEFAULT ((0)) FOR [REQ_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_ARS] ADD  CONSTRAINT [DF_CTI_STAT_ARS_CON_CALL]  DEFAULT ((0)) FOR [CON_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_ARS] ADD  CONSTRAINT [DF_CTI_STAT_ARS_AB_CALL]  DEFAULT ((0)) FOR [AB_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_ARS] ADD  CONSTRAINT [DF_CTI_STAT_ARS_CB_CALL]  DEFAULT ((0)) FOR [CB_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_ARS] ADD  CONSTRAINT [DF_CTI_STAT_ARS_SMS_CALL]  DEFAULT ((0)) FOR [SMS_CALL]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'S_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시간대' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'S_HOUR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요일(일요일 : 0 ~ 토요일 : 6)' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'S_WEEK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'GROUP_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'GROUP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총인입' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'TOTAL_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'단순끊음' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'DAN_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담요청' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'REQ_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담연결' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'CON_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객포기' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'AB_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'콜백' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'CB_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS발송' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'SMS_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약건수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'PMS_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원가입수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'REG_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담완료' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_ARS', @level2type=N'COLUMN',@level2name=N'FIN_CALL'
GO
