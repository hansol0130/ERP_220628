USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRO_TRANS_MASTER](
	[TRANS_CODE] [char](2) NOT NULL,
	[TRANS_NUMBER] [varchar](4) NOT NULL,
	[DEP_AIRPORT_CODE] [char](3) NOT NULL,
	[ARR_AIRPORT_CODE] [char](3) NOT NULL,
	[TRANS_TYPE] [int] NOT NULL,
	[DEP_TIME] [char](5) NULL,
	[ARR_TIME] [char](5) NULL,
	[WEEKDAY_TYPE] [char](7) NULL,
	[TRANS_INC] [varchar](500) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
	[TRANS_REAL_CODE] [varchar](2) NULL,
 CONSTRAINT [PK_PRO_TRANS_MASTER] PRIMARY KEY CLUSTERED 
(
	[TRANS_CODE] ASC,
	[TRANS_NUMBER] ASC,
	[DEP_AIRPORT_CODE] ASC,
	[ARR_AIRPORT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운항사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'TRANS_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: 항공, 2: 선박' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'TRANS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요일패턴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'WEEKDAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'TRANS_INC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제운항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER', @level2type=N'COLUMN',@level2name=N'TRANS_REAL_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운항정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER'
GO
