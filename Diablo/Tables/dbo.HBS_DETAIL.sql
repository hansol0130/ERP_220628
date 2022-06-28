USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HBS_DETAIL](
	[MASTER_SEQ] [int] NOT NULL,
	[BOARD_SEQ] [int] NOT NULL,
	[CATEGORY_SEQ] [int] NOT NULL,
	[PARENT_SEQ] [int] NOT NULL,
	[LEVEL] [int] NOT NULL,
	[STEP] [int] NOT NULL,
	[SUBJECT] [nvarchar](200) NULL,
	[CONTENTS] [text] NULL,
	[SHOW_COUNT] [int] NULL,
	[NOTICE_YN] [char](1) NULL,
	[DEL_YN] [char](1) NULL,
	[IP_ADDRESS] [varchar](15) NULL,
	[COMPLETE_YN] [char](1) NULL,
	[FILE_PATH] [nvarchar](255) NULL,
	[EDIT_PASS] [varchar](60) NULL,
	[LOCK_YN] [char](1) NULL,
	[MASTER_CODE] [varchar](20) NULL,
	[CNT_CODE] [int] NULL,
	[REGION_NAME] [varchar](30) NULL,
	[NICKNAME] [varchar](20) NULL,
	[PHONE_NUM] [varchar](30) NULL,
	[EMAIL] [varchar](50) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [int] NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
	[GOOD_TYPE_CD] [char](1) NULL,
	[AREA_CD] [char](2) NULL,
	[GOOD_YY] [char](4) NULL,
	[GOOD_SEQ] [int] NULL,
	[SEARCH_PK] [int] IDENTITY(1,1) NOT NULL,
	[RES_CODE] [varchar](20) NULL,
 CONSTRAINT [PK_HBS_DETAIL] PRIMARY KEY CLUSTERED 
(
	[MASTER_SEQ] ASC,
	[BOARD_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[HBS_DETAIL] ADD  CONSTRAINT [DF_HBS_DETAIL_LEVEL]  DEFAULT ((0)) FOR [LEVEL]
GO
ALTER TABLE [dbo].[HBS_DETAIL] ADD  CONSTRAINT [DF_HBS_DETAIL_STEP]  DEFAULT ((0)) FOR [STEP]
GO
ALTER TABLE [dbo].[HBS_DETAIL] ADD  CONSTRAINT [DF_HBS_DETAIL_SHOW_COUNT]  DEFAULT ((0)) FOR [SHOW_COUNT]
GO
ALTER TABLE [dbo].[HBS_DETAIL] ADD  CONSTRAINT [DF_HBS_DETAIL_DEL_YN]  DEFAULT ('N') FOR [DEL_YN]
GO
ALTER TABLE [dbo].[HBS_DETAIL] ADD  CONSTRAINT [DF_HBS_DETAIL_STATUS]  DEFAULT ('N') FOR [COMPLETE_YN]
GO
ALTER TABLE [dbo].[HBS_DETAIL] ADD  CONSTRAINT [HBS_DETAIL_LOCK_YN]  DEFAULT ('N') FOR [LOCK_YN]
GO
ALTER TABLE [dbo].[HBS_DETAIL] ADD  CONSTRAINT [DF_HBS_DETAIL_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[HBS_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK_HBS_DETAIL_HBS_MASTER] FOREIGN KEY([MASTER_SEQ])
REFERENCES [dbo].[HBS_MASTER] ([MASTER_SEQ])
GO
ALTER TABLE [dbo].[HBS_DETAIL] CHECK CONSTRAINT [FK_HBS_DETAIL_HBS_MASTER]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터순번(여행후기 = 1, 상품문의, 공지사항, _1_1문의, 맞춤여행, FAQ, 법인상담신청, 사이버홍보, 항공FAQ, 항공상식, 회사소개, 자유여행1_1문의, 이벤트공지사항, 허니문공지사항, 허니문1_1문의, 웹진, 골프1_1문의, 직원여행기, 고객의소리, 현지생생정보, 직원여행기_일본, 인솔자현지생생정보, 지역정보및여행후기, _1_1담당자별문의게시판, 자유게시판, 자유여행FAQ, 참좋은소식, 미디어소식, 여행레시피, 여행의발견)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'BOARD_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'CATEGORY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부모순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'PARENT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'레벨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'LEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'스텝' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'STEP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조회수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'SHOW_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공지유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'NOTICE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'삭제유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'DEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IP주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'IP_ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작업상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'COMPLETE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일경로' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'FILE_PATH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'패스워드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'EDIT_PASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'잠금여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'LOCK_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'컨텐츠코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'CNT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'REGION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'NICKNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연락처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'PHONE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성사원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GOOD_TYPE_CD(X)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'GOOD_TYPE_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'AREA_CD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GOOD_YY(X)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'GOOD_YY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GOOD_SEQ(X)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'GOOD_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'검색_인덱스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL', @level2type=N'COLUMN',@level2name=N'SEARCH_PK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보드디테일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HBS_DETAIL'
GO
