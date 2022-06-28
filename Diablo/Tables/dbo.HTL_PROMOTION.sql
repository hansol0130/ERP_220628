USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_PROMOTION](
	[PM_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[SUP_CODE] [varchar](10) NULL,
	[REGION_CODE] [dbo].[REGION_CODE] NULL,
	[NATION_CODE] [dbo].[NATION_CODE] NULL,
	[STATE_CODE] [dbo].[STATE_CODE] NULL,
	[CITY_CODE] [dbo].[CITY_CODE] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[MASTER_NAME] [nvarchar](400) NULL,
	[PM_TITLE] [nvarchar](50) NULL,
	[DIS_START_DATE] [datetime] NULL,
	[DIS_END_DATE] [datetime] NULL,
	[DIS_LEVEL] [int] NULL,
	[DIS_PERCENT] [decimal](4, 2) NULL,
	[DIS_DAY] [varchar](7) NULL,
	[REMARK] [nvarchar](100) NULL,
	[USE_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_HTL_PROMOTION] PRIMARY KEY CLUSTERED 
(
	[PM_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로모션번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'PM_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'SUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'STATE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'MASTER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'프로모션제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'PM_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'DIS_START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'DIS_END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용레벨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'DIS_LEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'DIS_PERCENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'할인요일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'DIS_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'활성유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔프로모션' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PROMOTION'
GO
