USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_FILE_MANAGER](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[FILE_CODE] [dbo].[FILE_CODE] NOT NULL,
	[SHOW_ORDER] [int] NULL,
 CONSTRAINT [PK_PKG_FILE_MANAGER] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[FILE_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_FILE_MANAGER]  WITH CHECK ADD  CONSTRAINT [R_287] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[PKG_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_FILE_MANAGER] CHECK CONSTRAINT [R_287]
GO
ALTER TABLE [dbo].[PKG_FILE_MANAGER]  WITH CHECK ADD  CONSTRAINT [R_288] FOREIGN KEY([FILE_CODE])
REFERENCES [dbo].[INF_FILE_MASTER] ([FILE_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_FILE_MANAGER] CHECK CONSTRAINT [R_288]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_FILE_MANAGER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_FILE_MANAGER', @level2type=N'COLUMN',@level2name=N'FILE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'표시순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_FILE_MANAGER', @level2type=N'COLUMN',@level2name=N'SHOW_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패키지파일관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_FILE_MANAGER'
GO
