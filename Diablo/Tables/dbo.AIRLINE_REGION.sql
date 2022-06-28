USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AIRLINE_REGION](
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NOT NULL,
	[GROUP_SEQ] [int] NOT NULL,
	[REGION_SEQ] [int] NOT NULL,
	[REGION_NAME] [varchar](30) NULL,
	[NATION_CODES] [varchar](500) NULL,
	[AIRPORT_CODES] [varchar](500) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_AIRLINE_REGION] PRIMARY KEY CLUSTERED 
(
	[AIRLINE_CODE] ASC,
	[GROUP_SEQ] ASC,
	[REGION_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION', @level2type=N'COLUMN',@level2name=N'GROUP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION', @level2type=N'COLUMN',@level2name=N'REGION_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'구분지역명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION', @level2type=N'COLUMN',@level2name=N'REGION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용국가코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION', @level2type=N'COLUMN',@level2name=N'NATION_CODES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION', @level2type=N'COLUMN',@level2name=N'AIRPORT_CODES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사지역구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_REGION'
GO
