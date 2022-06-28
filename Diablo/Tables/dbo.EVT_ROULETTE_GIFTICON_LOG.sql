USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_ROULETTE_GIFTICON_LOG](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[LOG_TYPE] [int] NOT NULL,
	[EVT_ROU_SEQ] [int] NOT NULL,
	[CUS_CODE] [int] NOT NULL,
	[TEL_NUMBER] [varchar](11) NOT NULL,
	[ORDER_ID] [varchar](20) NULL,
	[PRD_ID] [char](8) NOT NULL,
	[LOG_MSG] [varchar](200) NOT NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'로그타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'LOG_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'당첨순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'EVT_ROU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'CUS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주문아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'ORDER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메세지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'LOG_MSG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기프티콘로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_GIFTICON_LOG'
GO
