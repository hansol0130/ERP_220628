USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_ROULETTE_WINNER](
	[EVT_WIN_SEQ] [int] NOT NULL,
	[EVT_RESULT] [int] NULL,
	[WIN_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_EVT_ROULETTE_WINNER] PRIMARY KEY CLUSTERED 
(
	[EVT_WIN_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'당첨순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_WINNER', @level2type=N'COLUMN',@level2name=N'EVT_WIN_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'당첨결과' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_WINNER', @level2type=N'COLUMN',@level2name=N'EVT_RESULT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'당첨사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_WINNER', @level2type=N'COLUMN',@level2name=N'WIN_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_WINNER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_WINNER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룰렛이벤트당첨자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE_WINNER'
GO
