USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_COMMENT](
	[CNT_CODE] [dbo].[CNT_CODE] NOT NULL,
	[COM_SEQ] [int] NOT NULL,
	[COMMENT] [varchar](1000) NULL,
	[GRADE] [int] NULL,
	[POINT1] [int] NULL,
	[POINT2] [int] NULL,
	[POINT3] [int] NULL,
	[NICKNAME] [varchar](20) NULL,
	[CUS_NO] [dbo].[CUS_NO] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_INF_COMMENT] PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] ASC,
	[COM_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_COMMENT]  WITH CHECK ADD  CONSTRAINT [R_299] FOREIGN KEY([CNT_CODE])
REFERENCES [dbo].[INF_MASTER] ([CNT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INF_COMMENT] CHECK CONSTRAINT [R_299]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'평가순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'COM_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'COMMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'별점' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세점수1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'POINT1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세점수2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'POINT2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세점수3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'POINT3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'닉네임' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'NICKNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠평가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_COMMENT'
GO
