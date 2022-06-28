USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[CTI_STAT_REPORT_ETC](
	[S_DATE] [char](8) NOT NULL,
	[TEAM_CODE] [varchar](3) NOT NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[CHART_TYPE] [char](1) NOT NULL,
	[ITEM_NAME] [nvarchar](50) NOT NULL,
	[ITEM_COUNT] [int] NULL,
 CONSTRAINT [PK_CTI_STAT_REPORT_ETC] PRIMARY KEY CLUSTERED 
(
	[S_DATE] ASC,
	[TEAM_CODE] ASC,
	[CHART_TYPE] ASC,
	[ITEM_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 상담분류  2:성별 3:나이대 4:지역' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_REPORT_ETC', @level2type=N'COLUMN',@level2name=N'CHART_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'각 항목 이름' , @level0type=N'SCHEMA',@level0name=N'cti', @level1type=N'TABLE',@level1name=N'CTI_STAT_REPORT_ETC', @level2type=N'COLUMN',@level2name=N'ITEM_NAME'
GO
