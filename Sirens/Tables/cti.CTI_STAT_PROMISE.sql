USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_STAT_PROMISE](
	[S_DATE] [varchar](8) NOT NULL,
	[S_HOUR] [varchar](2) NOT NULL,
	[S_WEEK] [char](1) NOT NULL,
	[TEAM_CODE] [varchar](3) NOT NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[EMP_CODE] [nchar](7) NOT NULL,
	[EMP_NAME] [nchar](20) NULL,
	[RESERVE_COUNT] [int] NULL,
	[IN_CUST_COUNT] [int] NULL,
	[OUT_CUST_COUNT] [int] NULL,
	[ON_CALL_TIME] [bigint] NULL,
	[IN_CALL_COUNT] [int] NULL,
	[OUT_CALL_COUNT] [int] NULL,
	[PRE_CUST_COUNT] [int] NULL,
 CONSTRAINT [PK_CTI_STAT_PROMISE_1] PRIMARY KEY CLUSTERED 
(
	[S_DATE] ASC,
	[S_HOUR] ASC,
	[TEAM_CODE] ASC,
	[EMP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [cti].[CTI_STAT_PROMISE] ADD  CONSTRAINT [DF__CTI_STAT___RESER__625A9A57]  DEFAULT ((0)) FOR [RESERVE_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_PROMISE] ADD  CONSTRAINT [DF__CTI_STAT___IN_CU__634EBE90]  DEFAULT ((0)) FOR [IN_CUST_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_PROMISE] ADD  CONSTRAINT [DF__CTI_STAT___OUT_C__6442E2C9]  DEFAULT ((0)) FOR [OUT_CUST_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_PROMISE] ADD  CONSTRAINT [DF__CTI_STAT___ON_CA__65370702]  DEFAULT ((0)) FOR [ON_CALL_TIME]
GO
ALTER TABLE [cti].[CTI_STAT_PROMISE] ADD  CONSTRAINT [DF__CTI_STAT___IN_CA__662B2B3B]  DEFAULT ((0)) FOR [IN_CALL_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_PROMISE] ADD  CONSTRAINT [DF__CTI_STAT___OUT_C__671F4F74]  DEFAULT ((0)) FOR [OUT_CALL_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_PROMISE] ADD  CONSTRAINT [DF__CTI_STAT___PRE_C__681373AD]  DEFAULT ((0)) FOR [PRE_CUST_COUNT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'S_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시간대' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'S_HOUR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요일' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'S_WEEK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'EMP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약건수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'RESERVE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객약속발생건수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'IN_CUST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객약속처리건수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'OUT_CUST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객대기시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'ON_CALL_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'콜백발생건수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'IN_CALL_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'콜백처리건수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'OUT_CALL_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발전고객처리건수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_PROMISE', @level2type=N'COLUMN',@level2name=N'PRE_CUST_COUNT'
GO
