USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_ICN_CONDITION_V2](
	[DEP_DATE] [varchar](8) NOT NULL,
	[DEP_TIME] [varchar](5) NOT NULL,
	[T1_ENTRY_EAST_AB] [float] NULL,
	[T1_ENTRY_WEST_EF] [float] NULL,
	[T1_ENTRY_IMM_C] [float] NULL,
	[T1_ENTRY_IMM_D] [float] NULL,
	[T1_ENTRY_TOTAL] [float] NULL,
	[T1_DEP_12] [float] NULL,
	[T1_DEP_3] [float] NULL,
	[T1_DEP_4] [float] NULL,
	[T1_DEP_56] [float] NULL,
	[T1_DEP_TOTAL] [float] NULL,
	[T2_ENTRY_1] [float] NULL,
	[T2_ENTRY_2] [float] NULL,
	[T2_ENTRY_TOTAL] [float] NULL,
	[T2_DEP_1] [float] NULL,
	[T2_DEP_2] [float] NULL,
	[T2_DEP_TOTAL] [float] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_API_ICN_CONDITION_V2] PRIMARY KEY CLUSTERED 
(
	[DEP_DATE] ASC,
	[DEP_TIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'표출일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시간대' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 입국장 동편(A,B)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_ENTRY_EAST_AB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 입국장 서편(E,F)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_ENTRY_WEST_EF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 입국심사(C)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_ENTRY_IMM_C'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 입국심사(D)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_ENTRY_IMM_D'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 입국장 합계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_ENTRY_TOTAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 출국장1,2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_DEP_12'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 출국장3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_DEP_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 출국장4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_DEP_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T1 출국장5,6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_DEP_56'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출국장 합계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T1_DEP_TOTAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T2 입국장 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T2_ENTRY_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T2 입국장 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T2_ENTRY_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T2 입국장 합계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T2_ENTRY_TOTAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T2 출국장 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T2_DEP_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T2 출국장 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T2_DEP_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'T2 출국장 합계' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'T2_DEP_TOTAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인천공항 혼잡도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'API_ICN_CONDITION_V2'
GO
