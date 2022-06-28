USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_EVENT](
	[EVT_SEQ] [int] NOT NULL,
	[MASTER_CODE] [varchar](10) NULL,
	[SUP_CODE] [varchar](10) NULL,
	[EVT_NAME] [varchar](100) NULL,
	[EVT_START_DATE] [datetime] NULL,
	[EVT_END_DATE] [datetime] NULL,
	[EVT_DAY] [varchar](7) NULL,
	[EVT_REMARK] [varchar](1000) NULL,
	[USE_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EVT_INFO] [varchar](500) NULL,
 CONSTRAINT [PK_HTL_EVENT] PRIMARY KEY CLUSTERED 
(
	[EVT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔이벤트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공급자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'SUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용요일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔이벤트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_EVENT'
GO
