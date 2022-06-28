USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_GROUP](
	[GROUP_CODE] [varchar](10) NOT NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_PKG_GROUP] PRIMARY KEY CLUSTERED 
(
	[GROUP_CODE] ASC,
	[MASTER_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_GROUP]  WITH CHECK ADD  CONSTRAINT [R_32] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_GROUP] CHECK CONSTRAINT [R_32]
GO
ALTER TABLE [dbo].[PKG_GROUP]  WITH CHECK ADD  CONSTRAINT [R_PKG_GROUP_153] FOREIGN KEY([GROUP_CODE])
REFERENCES [dbo].[GRP_MASTER] ([GROUP_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_GROUP] CHECK CONSTRAINT [R_PKG_GROUP_153]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_GROUP', @level2type=N'COLUMN',@level2name=N'GROUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_GROUP', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_GROUP', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_GROUP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사그룹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_GROUP'
GO
