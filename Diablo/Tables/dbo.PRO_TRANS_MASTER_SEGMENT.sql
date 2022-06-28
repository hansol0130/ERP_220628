USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRO_TRANS_MASTER_SEGMENT](
	[TRANS_CODE] [dbo].[AIRLINE_CODE] NOT NULL,
	[TRANS_NUMBER] [varchar](4) NOT NULL,
	[DEP_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NOT NULL,
	[ARR_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NOT NULL,
	[SEG_NO] [int] NOT NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NULL,
	[FLIGHT] [varchar](20) NULL,
	[SEG_DEP_AIRPORT_CODE] [char](3) NULL,
	[SEG_ARR_AIRPORT_CODE] [char](3) NULL,
	[DEP_CHG_DAY] [int] NULL,
	[ARR_CHG_DAY] [int] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[DEP_TIME] [char](5) NULL,
	[ARR_TIME] [char](5) NULL,
	[REAL_AIRLINE_CODE] [char](2) NULL,
	[FLYING_TIME] [varchar](5) NULL,
 CONSTRAINT [PK_PRO_TRANS_MASTER_SEGMENT] PRIMARY KEY CLUSTERED 
(
	[TRANS_CODE] ASC,
	[TRANS_NUMBER] ASC,
	[DEP_AIRPORT_CODE] ASC,
	[ARR_AIRPORT_CODE] ASC,
	[SEG_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRO_TRANS_MASTER_SEGMENT]  WITH CHECK ADD  CONSTRAINT [R_254] FOREIGN KEY([TRANS_CODE], [TRANS_NUMBER], [DEP_AIRPORT_CODE], [ARR_AIRPORT_CODE], [SEG_NO])
REFERENCES [dbo].[PRO_TRANS_MASTER_SEGMENT] ([TRANS_CODE], [TRANS_NUMBER], [DEP_AIRPORT_CODE], [ARR_AIRPORT_CODE], [SEG_NO])
GO
ALTER TABLE [dbo].[PRO_TRANS_MASTER_SEGMENT] CHECK CONSTRAINT [R_254]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운항사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'TRANS_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세그순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEG_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경유시작공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEG_DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경유도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEG_ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발날짜변동일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_CHG_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착날짜변동일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_CHG_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착시각' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제운항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'REAL_AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비행시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLYING_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운항정보상세세그정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_MASTER_SEGMENT'
GO
