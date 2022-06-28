USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_UPDATE_RESULT](
	[SEQ_NO] [int] NULL,
	[RESULT_SEQ] [int] NULL,
	[UPDATE_TYPE] [varchar](20) NULL,
	[RESULT_CODE] [varchar](20) NULL,
	[RESULT_MESSAGE] [varchar](1000) NULL,
	[RESULT_TEXT] [varchar](max) NULL,
	[SEND_YN] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품변경사항 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_RESULT', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리 결과 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_RESULT', @level2type=N'COLUMN',@level2name=N'RESULT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'업데이트 타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_RESULT', @level2type=N'COLUMN',@level2name=N'UPDATE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리결과 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_RESULT', @level2type=N'COLUMN',@level2name=N'RESULT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리결과 메시지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_RESULT', @level2type=N'COLUMN',@level2name=N'RESULT_MESSAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리결과 상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_RESULT', @level2type=N'COLUMN',@level2name=N'RESULT_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정상전송여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_RESULT', @level2type=N'COLUMN',@level2name=N'SEND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_RESULT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
