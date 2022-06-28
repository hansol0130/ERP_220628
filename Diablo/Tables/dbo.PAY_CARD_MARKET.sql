USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_CARD_MARKET](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NULL,
	[POINT_PRICE] [money] NULL,
	[RES_CODE] [char](12) NULL,
	[POINT_NO] [int] NULL,
	[EXE_DATE] [datetime] NULL,
	[NEW_DATE] [datetime] NOT NULL,
 CONSTRAINT [PK_PAY_CARD_MARKET] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAY_CARD_MARKET] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CARD_MARKET', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CARD_MARKET', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CARD_MARKET', @level2type=N'COLUMN',@level2name=N'POINT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CARD_MARKET', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CARD_MARKET', @level2type=N'COLUMN',@level2name=N'POINT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트처리일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CARD_MARKET', @level2type=N'COLUMN',@level2name=N'EXE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_CARD_MARKET', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
