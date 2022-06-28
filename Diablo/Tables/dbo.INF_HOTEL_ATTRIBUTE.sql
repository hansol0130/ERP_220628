USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INF_HOTEL_ATTRIBUTE](
	[CNT_CODE] [dbo].[CNT_CODE] NOT NULL,
	[ATT_SEQ] [int] NOT NULL,
	[ATT_NAME] [nvarchar](20) NULL,
	[ATT_REMARK] [varchar](50) NULL,
	[SHOW_YN] [char](1) NULL,
 CONSTRAINT [PK_INF_HOTEL_ATTRIBUTE] PRIMARY KEY CLUSTERED 
(
	[CNT_CODE] ASC,
	[ATT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[INF_HOTEL_ATTRIBUTE]  WITH CHECK ADD  CONSTRAINT [R_197] FOREIGN KEY([CNT_CODE])
REFERENCES [dbo].[INF_HOTEL] ([CNT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INF_HOTEL_ATTRIBUTE] CHECK CONSTRAINT [R_197]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부대시설순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'ATT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부대시설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'ATT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'ATT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'활성유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL_ATTRIBUTE', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔부대시설' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INF_HOTEL_ATTRIBUTE'
GO
