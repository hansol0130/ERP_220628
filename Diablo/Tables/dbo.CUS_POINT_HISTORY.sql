USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_POINT_HISTORY](
	[POINT_NO] [int] NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[ACC_POINT_NO] [int] NOT NULL,
	[POINT_PRICE] [money] NOT NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NOT NULL,
	[ACC_TYPE] [int] NULL,
	[CXL_POINT_NO] [int] NULL,
 CONSTRAINT [PK_CUS_POINT_HISTORY] PRIMARY KEY CLUSTERED 
(
	[POINT_NO] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_POINT_HISTORY] ADD  CONSTRAINT [DEF_NUM_1_2071132101]  DEFAULT ((1)) FOR [ACC_POINT_NO]
GO
ALTER TABLE [dbo].[CUS_POINT_HISTORY]  WITH CHECK ADD  CONSTRAINT [FK_CUS_POINT_HISTORY_1] FOREIGN KEY([POINT_NO])
REFERENCES [dbo].[CUS_POINT] ([POINT_NO])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUS_POINT_HISTORY] CHECK CONSTRAINT [FK_CUS_POINT_HISTORY_1]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY', @level2type=N'COLUMN',@level2name=N'POINT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적립포인트번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY', @level2type=N'COLUMN',@level2name=N'ACC_POINT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY', @level2type=N'COLUMN',@level2name=N'POINT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'원래적립타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY', @level2type=N'COLUMN',@level2name=N'ACC_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소시포인트번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY', @level2type=N'COLUMN',@level2name=N'CXL_POINT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트 사용 내역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT_HISTORY'
GO
