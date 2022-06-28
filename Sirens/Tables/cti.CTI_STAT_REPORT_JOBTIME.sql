USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_STAT_REPORT_JOBTIME](
	[S_DATE] [char](8) NOT NULL,
	[TEAM_CODE] [varchar](3) NOT NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[JOBTIME_1] [int] NULL,
	[JOBTIME_2] [int] NULL,
	[JOBTIME_3] [int] NULL,
	[JOBTIME_4] [int] NULL,
	[JOBTIME_5] [int] NULL,
	[JOBTIME_6] [int] NULL,
	[INTIME_1] [int] NULL,
	[INTIME_2] [int] NULL,
	[INTIME_3] [int] NULL,
	[INTIME_4] [int] NULL,
	[INTIME_5] [int] NULL,
	[INTIME_6] [int] NULL,
	[OUTTIME_1] [int] NULL,
	[OUTTIME_2] [int] NULL,
	[OUTTIME_3] [int] NULL,
	[OUTTIME_4] [int] NULL,
	[OUTTIME_5] [int] NULL,
	[OUTTIME_6] [int] NULL,
 CONSTRAINT [PK_CTI_STAT_REPORT_JOBTIME] PRIMARY KEY CLUSTERED 
(
	[S_DATE] ASC,
	[TEAM_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1-2 시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_REPORT_JOBTIME', @level2type=N'COLUMN',@level2name=N'JOBTIME_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'2-3 시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_REPORT_JOBTIME', @level2type=N'COLUMN',@level2name=N'JOBTIME_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'3-4 시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_REPORT_JOBTIME', @level2type=N'COLUMN',@level2name=N'JOBTIME_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'4-5시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_REPORT_JOBTIME', @level2type=N'COLUMN',@level2name=N'JOBTIME_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'5-6시간' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_REPORT_JOBTIME', @level2type=N'COLUMN',@level2name=N'JOBTIME_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'6시간이상' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_REPORT_JOBTIME', @level2type=N'COLUMN',@level2name=N'JOBTIME_6'
GO
