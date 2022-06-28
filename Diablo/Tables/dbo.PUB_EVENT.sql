USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_EVENT](
	[EVT_SEQ] [int] NOT NULL,
	[PRO_CODE] [dbo].[PRO_CODE] NULL,
	[SIGN_CODE] [varchar](20) NULL,
	[ATT_CODE] [varchar](20) NULL,
	[EVT_NAME] [varchar](500) NULL,
	[EVT_SHORT_REMARK] [varchar](100) NULL,
	[EVT_URL] [varchar](500) NULL,
	[BANNER_URL] [varchar](500) NULL,
	[SHOW_ORDER] [int] NULL,
	[EVT_YN] [char](1) NULL,
	[BEST_YN] [char](1) NULL,
	[SHOW_YN] [char](1) NULL,
	[COMMENT_YN] [char](1) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[DEV_YN] [char](1) NULL,
	[DEV_SHOW_TYPE] [tinyint] NULL,
	[PROVIDER] [varchar](20) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[READ_COUNT] [int] NULL,
	[BEST_BANNER_URL] [varchar](500) NULL,
	[DEP_AIRLINE_CODE] [varchar](3) NULL,
	[MOBILE_URL] [varchar](500) NULL,
	[EVT_DESC] [varchar](1000) NULL,
	[MASTER_CODE] [varchar](20) NULL,
 CONSTRAINT [PK_PUB_EVENT] PRIMARY KEY CLUSTERED 
(
	[EVT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_EVENT] ADD  CONSTRAINT [DEF_PUB_EVENT_DEP_AIRLINE_CODE]  DEFAULT ('ICN') FOR [DEP_AIRLINE_CODE]
GO
ALTER TABLE [dbo].[PUB_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_PUB_EVENT_PUB_EVENT] FOREIGN KEY([EVT_SEQ])
REFERENCES [dbo].[PUB_EVENT] ([EVT_SEQ])
GO
ALTER TABLE [dbo].[PUB_EVENT] CHECK CONSTRAINT [FK_PUB_EVENT_PUB_EVENT]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'SIGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'속성코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'ATT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'간략설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_SHORT_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베너URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'BANNER_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'SHOW_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트사용여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'BEST_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'댓글여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'COMMENT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'개발페이지여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'DEV_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기획전템플릿타입 ( 0 : 전체, 1 : 사진형, 2 : 리뷰형 ) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'DEV_SHOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유입구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'PROVIDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'베스트배너URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'BEST_BANNER_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발항공코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'DEP_AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'모바일URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'MOBILE_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트상세설명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'EVT_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대표상품' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이벤트관리자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_EVENT'
GO
