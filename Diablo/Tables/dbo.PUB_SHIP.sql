USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_SHIP](
	[KOR_NAME] [varchar](100) NULL,
	[ENG_NAME] [varchar](100) NULL,
	[LINK_LVL] [char](18) NULL,
	[CRS] [varchar](20) NULL,
	[SORT_ORDER] [int] NULL,
	[DISPLAY_YN] [varchar](20) NULL,
	[AIR_NUM] [varchar](3) NULL,
	[SHIP_CODE] [char](2) NOT NULL,
 CONSTRAINT [PK_PUB_SHIP] PRIMARY KEY CLUSTERED 
(
	[SHIP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IDX_PUB_SHIP_1] UNIQUE NONCLUSTERED 
(
	[AIR_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_SHIP] ADD  CONSTRAINT [DEF_50]  DEFAULT ((50)) FOR [SORT_ORDER]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한굴항공사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문항공사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP', @level2type=N'COLUMN',@level2name=N'ENG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가입레벨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP', @level2type=N'COLUMN',@level2name=N'LINK_LVL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용CRS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP', @level2type=N'COLUMN',@level2name=N'CRS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP', @level2type=N'COLUMN',@level2name=N'SORT_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'표시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP', @level2type=N'COLUMN',@level2name=N'DISPLAY_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP', @level2type=N'COLUMN',@level2name=N'AIR_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선박사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP', @level2type=N'COLUMN',@level2name=N'SHIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선박' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_SHIP'
GO
