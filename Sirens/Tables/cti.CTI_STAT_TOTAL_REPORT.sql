USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_STAT_TOTAL_REPORT](
	[S_DATE] [varchar](8) NOT NULL,
	[GROUP_NO] [varchar](3) NOT NULL,
	[GROUP_NAME] [nvarchar](50) NULL,
	[TOTAL_CALL] [int] NULL,
	[DAN_CALL] [int] NULL,
	[REQ_CALL] [int] NULL,
	[CON_CALL] [int] NULL,
	[AB_CALL] [int] NULL,
	[CB_CALL] [int] NULL,
	[SMS_CALL] [int] NULL,
	[IN_CALL_TOTAL] [int] NULL,
	[IN_CALL_END] [int] NULL,
	[IN_CALL_AB] [int] NULL,
	[IN_CALL_TRF] [int] NULL,
	[IN_CALL_CUST_COUNT] [int] NULL,
	[IN_CALL_TIME] [int] NULL,
	[OUT_CALL_TOTAL] [int] NULL,
	[OUT_CALL_CUST_COUNT] [int] NULL,
	[OUT_CALL_TIME] [int] NULL,
	[PROMISE_TOTAL] [int] NULL,
	[PROMISE_END] [int] NULL,
	[EVA_CUST_COUNT] [int] NULL,
	[EVA_CUST_SUM] [int] NULL,
	[EVA_EMP_COUNT] [int] NULL,
	[EVA_EMP_SUM] [int] NULL,
	[RESERVE_COUNT] [int] NULL,
	[RESERVE_PER] [int] NULL,
	[RESERVE_AVG_CALL] [int] NULL,
	[RESERVE_AVG_TIME] [int] NULL,
	[PEAK_CUST] [int] NULL,
	[PEAK_CALL] [int] NULL,
	[TYPE_SEX_M] [int] NULL,
	[TYPE_SEX_W] [int] NULL,
	[TYPE_AGE_10] [int] NULL,
	[TYPE_AGE_20] [int] NULL,
	[TYPE_AGE_30] [int] NULL,
	[TYPE_AGE_40] [int] NULL,
	[TYPE_AGE_50] [int] NULL,
	[TYPE_AGE_60] [int] NULL,
	[TYPE_CONSULT_C] [int] NULL,
	[TYPE_CONSULT_R] [int] NULL,
	[TYPE_CONSULT_G] [int] NULL,
	[TYPE_CONSULT_N] [int] NULL,
 CONSTRAINT [PK_CTI_STAT_TOTAL_REPORT] PRIMARY KEY CLUSTERED 
(
	[S_DATE] ASC,
	[GROUP_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [cti].[CTI_STAT_TOTAL_REPORT] ADD  CONSTRAINT [DF_CTI_STAT_TOTAL_REPORT_TOTAL_CALL]  DEFAULT ((0)) FOR [TOTAL_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_TOTAL_REPORT] ADD  CONSTRAINT [DF_CTI_STAT_TOTAL_REPORT_DAN_CALL]  DEFAULT ((0)) FOR [DAN_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_TOTAL_REPORT] ADD  CONSTRAINT [DF_CTI_STAT_TOTAL_REPORT_REQ_CALL]  DEFAULT ((0)) FOR [REQ_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_TOTAL_REPORT] ADD  CONSTRAINT [DF_CTI_STAT_TOTAL_REPORT_CON_CALL]  DEFAULT ((0)) FOR [CON_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_TOTAL_REPORT] ADD  CONSTRAINT [DF_CTI_STAT_TOTAL_REPORT_AB_CALL]  DEFAULT ((0)) FOR [AB_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_TOTAL_REPORT] ADD  CONSTRAINT [DF_CTI_STAT_TOTAL_REPORT_CB_CALL]  DEFAULT ((0)) FOR [CB_CALL]
GO
ALTER TABLE [cti].[CTI_STAT_TOTAL_REPORT] ADD  CONSTRAINT [DF_CTI_STAT_TOTAL_REPORT_SMS_CALL]  DEFAULT ((0)) FOR [SMS_CALL]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'S_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'GROUP_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'GROUP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'TOTAL_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'DAN_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'REQ_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'CON_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'AB_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'CB_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'SMS_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'IN_CALL_TOTAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'IN_CALL_END'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'IN_CALL_CUST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????? ??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'IN_CALL_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'OUT_CALL_TOTAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'OUT_CALL_CUST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'OUT_CALL_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'PROMISE_TOTAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'PROMISE_END'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ?????? ?????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'EVA_CUST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'EVA_CUST_SUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????? ?????? ?????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'EVA_EMP_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'EVA_EMP_SUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'RESERVE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'RESERVE_PER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'RESERVE_AVG_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'RESERVE_AVG_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'PEAK_CUST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ????????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'PEAK_CALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'TYPE_SEX_M'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ?????????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'TYPE_AGE_10'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'TYPE_CONSULT_C'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'TYPE_CONSULT_R'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'TYPE_CONSULT_G'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????? ???????????? ??????' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_TOTAL_REPORT', @level2type=N'COLUMN',@level2name=N'TYPE_CONSULT_N'
GO
