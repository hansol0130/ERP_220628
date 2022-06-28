USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_POPUP](
	[POPIDX] [int] NOT NULL,
	[POPTITLE] [varchar](50) NULL,
	[POPHREF] [varchar](500) NULL,
	[POPSRC] [varchar](500) NULL,
	[POPWIDTH] [int] NULL,
	[POPHEIGHT] [int] NULL,
	[POPISIFRAME] [char](1) NULL,
	[POPTOP] [int] NULL,
	[POPLEFT] [int] NULL,
	[POPZINDEX] [int] NULL,
	[POPSTARTDATE] [varchar](10) NULL,
	[POPSTARTTIME] [varchar](10) NULL,
	[POPENDDATE] [varchar](10) NULL,
	[POPENDTIME] [varchar](10) NULL,
	[POPDAY] [varchar](15) NULL,
	[POPOPTION] [varchar](1000) NULL,
	[POPISPAUSE] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[POPDAYSTARTTIME] [varchar](10) NULL,
	[POPDAYENDTIME] [varchar](10) NULL,
	[HORIZONALIGN] [varchar](1) NULL,
	[POPMOBILESRC] [varchar](500) NULL,
 CONSTRAINT [PK_PUB_POPUP] PRIMARY KEY CLUSTERED 
(
	[POPIDX] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팝업순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPIDX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPTITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'링크' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPHREF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPSRC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPWIDTH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPHEIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이프레임유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPISIFRAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TOP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPTOP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LEFT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPLEFT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ZINDEX' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPZINDEX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPSTARTDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPSTARTTIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPENDDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPENDTIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPDAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'URL옵션' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPOPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPISPAUSE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'NEW_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'EDT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팝업시작일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPDAYSTARTTIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팝업종료일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'POPDAYENDTIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수평정렬값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP', @level2type=N'COLUMN',@level2name=N'HORIZONALIGN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팝업관리자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_POPUP'
GO
