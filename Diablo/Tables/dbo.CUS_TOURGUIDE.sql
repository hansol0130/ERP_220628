USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_TOURGUIDE](
	[TG_CODE] [varchar](10) NOT NULL,
	[TG_NAME] [varchar](50) NULL,
	[TG_TYPE] [varchar](1) NULL,
	[PARENT_TG_CODE] [varchar](10) NULL,
	[FILE_NUM] [int] NULL,
	[ORDER_NUM] [int] NULL,
 CONSTRAINT [PK_CUS_TOURGUIDE] PRIMARY KEY CLUSTERED 
(
	[TG_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행가이드코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_TOURGUIDE', @level2type=N'COLUMN',@level2name=N'TG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메뉴명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_TOURGUIDE', @level2type=N'COLUMN',@level2name=N'TG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여가타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_TOURGUIDE', @level2type=N'COLUMN',@level2name=N'TG_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부모코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_TOURGUIDE', @level2type=N'COLUMN',@level2name=N'PARENT_TG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_TOURGUIDE', @level2type=N'COLUMN',@level2name=N'FILE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_TOURGUIDE', @level2type=N'COLUMN',@level2name=N'ORDER_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행가이드메뉴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_TOURGUIDE'
GO
