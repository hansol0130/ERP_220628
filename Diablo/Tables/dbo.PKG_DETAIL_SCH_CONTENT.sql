USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL_SCH_CONTENT](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[SCH_SEQ] [int] NOT NULL,
	[DAY_SEQ] [int] NOT NULL,
	[CITY_SEQ] [int] NOT NULL,
	[CNT_SEQ] [int] NOT NULL,
	[CNT_CODE] [int] NULL,
	[CNT_INFO] [nvarchar](max) NULL,
	[CNT_SHOW_ORDER] [int] NULL,
 CONSTRAINT [PK_PKG_DETAIL_SCH_CONTENT] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[SCH_SEQ] ASC,
	[DAY_SEQ] ASC,
	[CITY_SEQ] ASC,
	[CNT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_DETAIL_SCH_CONTENT]  WITH CHECK ADD  CONSTRAINT [R_149] FOREIGN KEY([PRO_CODE], [SCH_SEQ], [DAY_SEQ], [CITY_SEQ])
REFERENCES [dbo].[PKG_DETAIL_SCH_CITY] ([PRO_CODE], [SCH_SEQ], [DAY_SEQ], [CITY_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_DETAIL_SCH_CONTENT] CHECK CONSTRAINT [R_149]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT', @level2type=N'COLUMN',@level2name=N'SCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT', @level2type=N'COLUMN',@level2name=N'DAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT', @level2type=N'COLUMN',@level2name=N'CITY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT', @level2type=N'COLUMN',@level2name=N'CNT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT', @level2type=N'COLUMN',@level2name=N'CNT_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT', @level2type=N'COLUMN',@level2name=N'CNT_SHOW_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사컨텐츠' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_CONTENT'
GO
