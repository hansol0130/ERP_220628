USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_STAT_WORKTIME](
	[S_DATE] [varchar](8) NOT NULL,
	[TEAM_CODE] [varchar](3) NOT NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[EMP_CODE] [nchar](7) NOT NULL,
	[EMP_NAME] [nchar](20) NULL,
	[IN_WORK_TIME] [int] NULL,
	[OUT_WORK_TIME] [int] NULL,
	[IN_CALL_TIME] [int] NULL,
	[OUT_CALL_TIME] [int] NULL,
	[IN_CALL_COUNT] [int] NULL,
	[IN_CON_COUNT] [int] NULL,
	[IN_AB_COUNT] [int] NULL,
	[IN_CUST_COUNT] [int] NULL,
	[OUT_CALL_COUNT] [int] NULL,
	[OUT_CUST_COUNT] [int] NULL,
	[PICKUP_COUNT] [int] NULL,
	[TRANSFER_COUNT] [int] NULL,
	[RESERVE_COUNT] [int] NULL,
 CONSTRAINT [PK_CTI_STAT_WORKTIME_1] PRIMARY KEY CLUSTERED 
(
	[S_DATE] ASC,
	[TEAM_CODE] ASC,
	[EMP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF_CTI_STAT_WORKTIME_IN_WORK_TIME]  DEFAULT ((0)) FOR [IN_WORK_TIME]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF__CTI_STAT___WORK___4E1E9780]  DEFAULT ((0)) FOR [OUT_WORK_TIME]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF_CTI_STAT_WORKTIME_IN_CALL_TIME]  DEFAULT ((0)) FOR [IN_CALL_TIME]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF_CTI_STAT_WORKTIME_OUT_CALL_TIME]  DEFAULT ((0)) FOR [OUT_CALL_TIME]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF__CTI_STAT___IN_CA__50FB042B]  DEFAULT ((0)) FOR [IN_CALL_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF__CTI_STAT___OUT_C__51EF2864]  DEFAULT ((0)) FOR [IN_CON_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF__CTI_STAT___TOTAL__52E34C9D]  DEFAULT ((0)) FOR [IN_AB_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF__CTI_STAT___RES_C__53D770D6]  DEFAULT ((0)) FOR [IN_CUST_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF__CTI_STAT___AB_CA__54CB950F]  DEFAULT ((0)) FOR [OUT_CALL_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF__CTI_STAT___SEND___55BFB948]  DEFAULT ((0)) FOR [OUT_CUST_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF_CTI_STAT_WORKTIME_PICKUP_COUNT]  DEFAULT ((0)) FOR [PICKUP_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF_CTI_STAT_WORKTIME_TRANSFER_COUNT]  DEFAULT ((0)) FOR [TRANSFER_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_WORKTIME] ADD  CONSTRAINT [DF_CTI_STAT_WORKTIME_RESERVE_COUNT]  DEFAULT ((0)) FOR [RESERVE_COUNT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'S_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'EMP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신상담시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'IN_WORK_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발신상담시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'OUT_WORK_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신통화시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'IN_CALL_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발신통화시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'OUT_CALL_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총수신' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'IN_CALL_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'총응대' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'IN_CON_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부재' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'IN_AB_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신고객수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'IN_CUST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발신통화수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'OUT_CALL_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발신고객수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'OUT_CUST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'당겨받기' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'PICKUP_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전환' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'TRANSFER_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_WORKTIME', @level2type=N'COLUMN',@level2name=N'RESERVE_COUNT'
GO
