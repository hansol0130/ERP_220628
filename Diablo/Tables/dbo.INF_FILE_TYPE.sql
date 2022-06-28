USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_FILE_TYPE](
	[FILE_CODE] [int] NOT NULL,
	[FILE_ATT_CODE] [int] NOT NULL,
	[SHOW_YN] [char](1) NULL,
 CONSTRAINT [PK_INF_FILE_TYPE] PRIMARY KEY CLUSTERED 
(
	[FILE_CODE] ASC,
	[FILE_ATT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_FILE_TYPE]  WITH CHECK ADD  CONSTRAINT [R_44] FOREIGN KEY([FILE_CODE])
REFERENCES [dbo].[INF_FILE_MASTER] ([FILE_CODE])
GO
ALTER TABLE [dbo].[INF_FILE_TYPE] CHECK CONSTRAINT [R_44]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_TYPE', @level2type=N'COLUMN',@level2name=N'FILE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_TYPE', @level2type=N'COLUMN',@level2name=N'FILE_ATT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_TYPE', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일속성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_FILE_TYPE'
GO
