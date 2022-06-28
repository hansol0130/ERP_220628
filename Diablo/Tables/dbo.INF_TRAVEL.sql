USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_TRAVEL](
	[CNT_CODE] [int] NOT NULL,
	[SUB_TITLE] [nvarchar](200) NULL,
	[ADDRESS] [nvarchar](200) NULL,
	[PHONE] [varchar](30) NULL,
	[HOMEPAGE] [varchar](100) NULL,
	[PRICE] [nvarchar](200) NULL,
	[TRAFFIC] [nvarchar](1000) NULL,
	[OP_TIME] [nvarchar](200) NULL,
	[CHECK_POINT] [nvarchar](1000) NULL,
 CONSTRAINT [PK_INF_TRAVEL] PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_TRAVEL]  WITH CHECK ADD  CONSTRAINT [FK__INF_TRAVE__CNT_C__28D80438] FOREIGN KEY([CNT_CODE])
REFERENCES [dbo].[INF_MASTER] ([CNT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INF_TRAVEL] CHECK CONSTRAINT [FK__INF_TRAVE__CNT_C__28D80438]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부가제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'SUB_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'홈페이지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요금' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'교통편' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'TRAFFIC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'OP_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'체크포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL', @level2type=N'COLUMN',@level2name=N'CHECK_POINT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관광지컨텐츠' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_TRAVEL'
GO
