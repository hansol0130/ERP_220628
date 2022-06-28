USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_TYPE](
	[CNT_CODE] [int] NOT NULL,
	[CNT_ATT_CODE] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] ASC,
	[CNT_ATT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_TYPE]  WITH CHECK ADD  CONSTRAINT [R_17] FOREIGN KEY([CNT_CODE])
REFERENCES [dbo].[INF_MASTER] ([CNT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INF_TYPE] CHECK CONSTRAINT [R_17]
GO
ALTER TABLE [dbo].[INF_TYPE]  WITH CHECK ADD  CONSTRAINT [R_88] FOREIGN KEY([CNT_ATT_CODE])
REFERENCES [dbo].[INF_ATTRIBUTE] ([CNT_ATT_CODE])
GO
ALTER TABLE [dbo].[INF_TYPE] CHECK CONSTRAINT [R_88]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TYPE', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠타입코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TYPE', @level2type=N'COLUMN',@level2name=N'CNT_ATT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠속성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TYPE'
GO
