USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_HTL_CUSTOMER_DETAIL](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[ROOM_NO] [int] NOT NULL,
	[MATCH_NO] [int] NOT NULL,
	[SEQ_NO] [int] NULL,
	[AGE] [int] NULL,
 CONSTRAINT [PK_RES_HTL_CUSTOMER_DETAIL] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[ROOM_NO] ASC,
	[MATCH_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_HTL_CUSTOMER_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_241] FOREIGN KEY([RES_CODE], [ROOM_NO])
REFERENCES [dbo].[RES_HTL_ROOM_DETAIL] ([RES_CODE], [ROOM_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_HTL_CUSTOMER_DETAIL] CHECK CONSTRAINT [R_241]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'ROOM_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매치순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'MATCH_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_CUSTOMER_DETAIL', @level2type=N'COLUMN',@level2name=N'AGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔 숙박자 정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_HTL_CUSTOMER_DETAIL'
GO
