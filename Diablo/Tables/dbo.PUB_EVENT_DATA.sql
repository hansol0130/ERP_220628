USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_EVENT_DATA](
	[EVT_SEQ] [int] NOT NULL,
	[EVT_DATA_SEQ] [int] NOT NULL,
	[CATEGORY] [int] NULL,
	[SUB_CATEGORY] [int] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[PRO_CODE] [varchar](100) NULL,
	[PRICE_SEQ] [int] NULL,
	[CODE_TYPE] [int] NULL,
	[SHOW_YN] [char](1) NULL,
	[SORT_NUM] [varchar](5) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_PUB_EVENT_DATA_1] PRIMARY KEY CLUSTERED 
(
	[EVT_DATA_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_EVENT_DATA]  WITH CHECK ADD  CONSTRAINT [R_333] FOREIGN KEY([EVT_SEQ])
REFERENCES [dbo].[PUB_EVENT] ([EVT_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PUB_EVENT_DATA] CHECK CONSTRAINT [R_333]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'EVT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'EVT_DATA_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'CATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보조카테고리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'SUB_CATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터행사구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'CODE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'SORT_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트행사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT_DATA'
GO
