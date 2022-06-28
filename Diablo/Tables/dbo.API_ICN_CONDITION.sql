USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_ICN_CONDITION](
	[DEP_DATE] [datetime] NOT NULL,
	[DEP_TIME] [varchar](20) NOT NULL,
	[EAST_AB] [int] NULL,
	[WEST_EF] [int] NULL,
	[IMM_C] [int] NULL,
	[IMM_D] [int] NULL,
	[GATE_12] [int] NULL,
	[GATE_3] [int] NULL,
	[GATE_4] [int] NULL,
	[GATE_56] [int] NULL,
	[TOT_1] [int] NULL,
	[TOT_2] [int] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
 CONSTRAINT [PK_API_ICN_CONDITION] PRIMARY KEY CLUSTERED 
(
	[DEP_DATE] ASC,
	[DEP_TIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동편AB' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'EAST_AB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'서편EF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'WEST_EF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입국심사C' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'IMM_C'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입국심사D' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'IMM_D'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국장12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'GATE_12'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국장3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'GATE_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국장4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'GATE_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국장56' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'GATE_56'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'합계1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'TOT_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'합계2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'TOT_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인천공항 혼잡도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION'
GO
