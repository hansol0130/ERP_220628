USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_POINT](
	[CUS_NO] [dbo].[CUS_NO] NOT NULL,
	[POINT_NO] [int] IDENTITY(1,1) NOT NULL,
	[POINT_TYPE] [int] NOT NULL,
	[ACC_USE_TYPE] [int] NOT NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[POINT_PRICE] [money] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[TITLE] [nvarchar](200) NULL,
	[TOTAL_PRICE] [money] NOT NULL,
	[MASTER_SEQ] [int] NULL,
	[BOARD_SEQ] [int] NULL,
	[REMARK] [varchar](200) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NOT NULL,
	[IS_CXL] [tinyint] NULL,
	[ORG_POINT_NO] [int] NULL,
 CONSTRAINT [PK_CUS_POINT] PRIMARY KEY CLUSTERED 
(
	[POINT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUS_POINT] ADD  CONSTRAINT [DEF_NUM_1_740996355]  DEFAULT ((1)) FOR [ACC_USE_TYPE]
GO
ALTER TABLE [dbo].[CUS_POINT] ADD  DEFAULT ((0)) FOR [IS_CXL]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'POINT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트 타입 (1 : 적립, 2 : 사용)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'POINT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적립종류(일반적립 = 1, 관리자적립 = 2, 회원가입 = 3, 컨텐츠적립 = 4, 이벤트적립 = 5, 포인트이전 = 6, 추천인 = 7, 피추천인 = 8, VIP추가적립 = 9, 기타 = 99) 사용종류 (일반사용 = 1, 기간만료 = 2, 관리자차감 = 3, 포인트이전 = 4, 탈퇴소멸 = 5, 사용취소 = 6, OK캐쉬백사용 =  7, 기타 = 9)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'ACC_USE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유효기간 시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유효기간 종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'POINT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'잔액 포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'TOTAL_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판 마스터 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'MASTER_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시물 번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'BOARD_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'포인트취소여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'IS_CXL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'양도적립시원래포인트번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT', @level2type=N'COLUMN',@level2name=N'ORG_POINT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객 포인트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_POINT'
GO
