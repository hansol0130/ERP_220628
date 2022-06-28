USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_HTL_ROOM_DETAIL](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[ROOM_NO] [int] NOT NULL,
	[ROOM_TYPE] [int] NULL,
	[ROOM_NAME] [varchar](200) NULL,
	[ROOM_COUNT] [int] NULL,
	[BREAKFAST_YN] [char](1) NULL,
	[PRICE_SEQ] [int] NULL,
 CONSTRAINT [PK_RES_HTL_ROOM_DETAIL] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[ROOM_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_HTL_ROOM_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_224] FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_HTL_ROOM_MASTER] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_HTL_ROOM_DETAIL] CHECK CONSTRAINT [R_224]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_DETAIL', @level2type=N'COLUMN',@level2name=N'ROOM_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_DETAIL', @level2type=N'COLUMN',@level2name=N'ROOM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_DETAIL', @level2type=N'COLUMN',@level2name=N'ROOM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸갯수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_DETAIL', @level2type=N'COLUMN',@level2name=N'ROOM_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조식여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_DETAIL', @level2type=N'COLUMN',@level2name=N'BREAKFAST_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_DETAIL', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔예약룸세부정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_ROOM_DETAIL'
GO
