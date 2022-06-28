USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_STAT_EVALUATION](
	[S_DATE] [varchar](6) NOT NULL,
	[TEAM_CODE] [varchar](3) NOT NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[EMP_CODE] [nchar](7) NOT NULL,
	[EMP_NAME] [nchar](20) NULL,
	[CUST_COUNT] [int] NULL,
	[CUST_POINT] [int] NULL,
	[MON_POINT] [int] NULL,
 CONSTRAINT [PK_CTI_STAT_EVALUATION_1] PRIMARY KEY CLUSTERED 
(
	[S_DATE] ASC,
	[TEAM_CODE] ASC,
	[EMP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [cti].[CTI_STAT_EVALUATION] ADD  DEFAULT ((0)) FOR [CUST_COUNT]
GO
ALTER TABLE [cti].[CTI_STAT_EVALUATION] ADD  DEFAULT ((0)) FOR [CUST_POINT]
GO
ALTER TABLE [cti].[CTI_STAT_EVALUATION] ADD  DEFAULT ((0)) FOR [MON_POINT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리년월' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_EVALUATION', @level2type=N'COLUMN',@level2name=N'S_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_EVALUATION', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_EVALUATION', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원번호' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_EVALUATION', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원명' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_EVALUATION', @level2type=N'COLUMN',@level2name=N'EMP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객평가인원' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_EVALUATION', @level2type=N'COLUMN',@level2name=N'CUST_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객평가점수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_EVALUATION', @level2type=N'COLUMN',@level2name=N'CUST_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모니터링평가점수' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_EVALUATION', @level2type=N'COLUMN',@level2name=N'MON_POINT'
GO
