USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_FILE_MANAGER](
	[CNT_CODE] [int] NOT NULL,
	[FILE_CODE] [int] NOT NULL,
	[SHOW_ORDER] [int] NULL,
 CONSTRAINT [PK_INF_FILE_MANAGER] PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] ASC,
	[FILE_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_FILE_MANAGER] ADD  CONSTRAINT [DF_INF_FILE_MANAGER_SHOW_ORDER]  DEFAULT ((5)) FOR [SHOW_ORDER]
GO
ALTER TABLE [dbo].[INF_FILE_MANAGER]  WITH CHECK ADD  CONSTRAINT [R_19] FOREIGN KEY([CNT_CODE])
REFERENCES [dbo].[INF_MASTER] ([CNT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INF_FILE_MANAGER] CHECK CONSTRAINT [R_19]
GO
ALTER TABLE [dbo].[INF_FILE_MANAGER]  WITH CHECK ADD  CONSTRAINT [R_36] FOREIGN KEY([FILE_CODE])
REFERENCES [dbo].[INF_FILE_MASTER] ([FILE_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INF_FILE_MANAGER] CHECK CONSTRAINT [R_36]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MANAGER', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MANAGER', @level2type=N'COLUMN',@level2name=N'FILE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'표시순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MANAGER', @level2type=N'COLUMN',@level2name=N'SHOW_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠파일관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_MANAGER'
GO
