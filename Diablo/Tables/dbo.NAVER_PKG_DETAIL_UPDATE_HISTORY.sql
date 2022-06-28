USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAVER_PKG_DETAIL_UPDATE_HISTORY](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[MASTER_CODE] [varchar](10) NULL,
	[CHILD_CODE] [varchar](30) NULL,
	[UPDATE_CATE] [varchar](20) NULL,
	[UPDATE_TARGET] [varchar](20) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [varchar](7) NULL,
	[CHK_DATE] [datetime] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품변경사항 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_HISTORY', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_HISTORY', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_HISTORY', @level2type=N'COLUMN',@level2name=N'CHILD_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 유입처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_HISTORY', @level2type=N'COLUMN',@level2name=N'UPDATE_CATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정 대상' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_HISTORY', @level2type=N'COLUMN',@level2name=N'UPDATE_TARGET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자사번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NAVER_PKG_DETAIL_UPDATE_HISTORY', @level2type=N'COLUMN',@level2name=N'CHK_DATE'
GO
