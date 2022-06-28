USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_AIRLINE_COMMISION](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[AIRLINE_CODE] [char](2) NOT NULL,
	[COMMISION] [int] NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[REGION_CODE] [char](3) NULL,
	[NATION_CODE] [char](3) NULL,
	[STATE_CODE] [char](4) NULL,
	[CITY_CODE] [char](3) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_CODE] [char](18) NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](18) NULL,
 CONSTRAINT [PK__PUB_AIRLINE_COMM__43F6DA1F] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC,
	[AIRLINE_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_AIRLINE_COMMISION] ADD  CONSTRAINT [DF__PUB_AIRLI__CREAT__44EAFE58]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'커미션' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'COMMISION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'커미션시작일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'커미션종료일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'REGION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'NATION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'STATE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사 커미션' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE_COMMISION'
GO
