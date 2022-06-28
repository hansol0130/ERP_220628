USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_ATTRIBUTE](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[ATT_CODE] [char](1) NOT NULL,
 CONSTRAINT [PK_PKG_ATTRIBUTE] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[ATT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_ATTRIBUTE]  WITH CHECK ADD  CONSTRAINT [R_11] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_ATTRIBUTE] CHECK CONSTRAINT [R_11]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'속성코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'ATT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터 속성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_ATTRIBUTE'
GO
