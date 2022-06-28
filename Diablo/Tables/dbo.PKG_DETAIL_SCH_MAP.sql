USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL_SCH_MAP](
	[PRO_CODE] [varchar](20) NOT NULL,
	[SCH_SEQ] [int] NOT NULL,
	[DAY_SEQ] [int] NOT NULL,
	[MASTER_CODE] [varchar](10) NULL,
	[DAY_NUMBER] [int] NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[MAP_SEQ] [int] NULL,
 CONSTRAINT [PK_PKG_DETAIL_SCH_MAP] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[SCH_SEQ] ASC,
	[DAY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_DETAIL_SCH_MAP]  WITH CHECK ADD  CONSTRAINT [R_540] FOREIGN KEY([MASTER_CODE], [DAY_NUMBER], [MAP_SEQ])
REFERENCES [dbo].[PKG_MASTER_SCH_MAP] ([MASTER_CODE], [DAY_NUMBER], [MAP_SEQ])
GO
ALTER TABLE [dbo].[PKG_DETAIL_SCH_MAP] CHECK CONSTRAINT [R_540]
GO
ALTER TABLE [dbo].[PKG_DETAIL_SCH_MAP]  WITH CHECK ADD  CONSTRAINT [R_541] FOREIGN KEY([PRO_CODE], [SCH_SEQ])
REFERENCES [dbo].[PKG_DETAIL_SCH_MASTER] ([PRO_CODE], [SCH_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_DETAIL_SCH_MAP] CHECK CONSTRAINT [R_541]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP', @level2type=N'COLUMN',@level2name=N'SCH_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP', @level2type=N'COLUMN',@level2name=N'DAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP', @level2type=N'COLUMN',@level2name=N'DAY_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지도순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP', @level2type=N'COLUMN',@level2name=N'MAP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'일정별_스테틱맵' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_SCH_MAP'
GO
