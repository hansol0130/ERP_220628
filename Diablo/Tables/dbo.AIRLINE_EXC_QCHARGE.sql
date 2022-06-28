USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AIRLINE_EXC_QCHARGE](
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NOT NULL,
	[START_YEAR] [int] NOT NULL,
	[EXC_SEQ] [int] NOT NULL,
	[NATION_CODES] [varchar](200) NULL,
	[AIRPORT_CODES] [varchar](200) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[QCHARGE_PRICE] [decimal](10, 0) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[ADT_QCHARGE] [int] NULL,
	[CHD_QCHARGE] [int] NULL,
	[INF_QCHARGE] [int] NULL,
 CONSTRAINT [PK_AIRLINE_EXC_QCHARGE] PRIMARY KEY CLUSTERED 
(
	[AIRLINE_CODE] ASC,
	[START_YEAR] ASC,
	[EXC_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용년도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'START_YEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요금순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'EXC_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'NATION_CODES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'AIRPORT_CODES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'QCHARGE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'ADT_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'CHD_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE', @level2type=N'COLUMN',@level2name=N'INF_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사예외유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_EXC_QCHARGE'
GO
