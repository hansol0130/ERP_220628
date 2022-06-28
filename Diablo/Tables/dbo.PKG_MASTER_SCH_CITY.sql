USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_MASTER_SCH_CITY](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[SCH_SEQ] [int] NOT NULL,
	[DAY_SEQ] [int] NOT NULL,
	[CITY_SEQ] [int] NOT NULL,
	[CITY_CODE] [char](3) NULL,
	[MAINCITY_YN] [char](1) NULL,
	[CITY_SHOW_ORDER] [int] NULL,
 CONSTRAINT [PK_PKG_MASTER_SCH_CITY] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[SCH_SEQ] ASC,
	[DAY_SEQ] ASC,
	[CITY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_MASTER_SCH_CITY]  WITH CHECK ADD  CONSTRAINT [R_151] FOREIGN KEY([MASTER_CODE], [SCH_SEQ], [DAY_SEQ])
REFERENCES [dbo].[PKG_MASTER_SCH_DAY] ([MASTER_CODE], [SCH_SEQ], [DAY_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_MASTER_SCH_CITY] CHECK CONSTRAINT [R_151]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_CITY', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_CITY', @level2type=N'COLUMN',@level2name=N'SCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_CITY', @level2type=N'COLUMN',@level2name=N'DAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_CITY', @level2type=N'COLUMN',@level2name=N'CITY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_CITY', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메인도시유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_CITY', @level2type=N'COLUMN',@level2name=N'MAINCITY_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_CITY', @level2type=N'COLUMN',@level2name=N'CITY_SHOW_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터일정도시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_MASTER_SCH_CITY'
GO
