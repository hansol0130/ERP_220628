USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVT_ROULETTE](
	[EVT_ROU_SEQ] [int] NOT NULL,
	[EVT_WIN_SEQ] [int] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[RES_SEQ_NO] [int] NULL,
	[CUS_CODE] [int] NULL,
	[EVT_RESULT] [int] NULL,
	[EVT_PRODUCT] [varchar](70) NULL,
	[COP_USE_YN] [char](1) NULL,
	[GIFT_SEND_YN] [char](1) NULL,
	[REMARK] [varchar](100) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_EVT_ROULETTE] PRIMARY KEY CLUSTERED 
(
	[EVT_ROU_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'EVT_ROU_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'당첨순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'EVT_WIN_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'RES_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'CUS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트결과' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'EVT_RESULT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트상품' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'EVT_PRODUCT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'쿠폰사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'COP_USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기프티콘발송유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'GIFT_SEND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룰렛이벤트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EVT_ROULETTE'
GO
