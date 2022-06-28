USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PKG_DETAIL_FILE](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[FILE_CODE] [int] NOT NULL,
	[SHOW_ORDER] [int] NULL,
 CONSTRAINT [PK_PKG_DETAIL_FILE] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[FILE_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PKG_DETAIL_FILE]  WITH CHECK ADD  CONSTRAINT [R_33] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[PKG_DETAIL] ([PRO_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PKG_DETAIL_FILE] CHECK CONSTRAINT [R_33]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_FILE', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_FILE', @level2type=N'COLUMN',@level2name=N'FILE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'표시순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_FILE', @level2type=N'COLUMN',@level2name=N'SHOW_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사파일정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PKG_DETAIL_FILE'
GO
