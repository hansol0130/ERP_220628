USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRI_SCHEDULE](
	[SEQ_NO] [dbo].[SEQ_NO] IDENTITY(1,1) NOT NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
	[SCH_TYPE] [char](1) NULL,
	[SCH_DATE] [datetime] NULL,
	[SUBJECT] [varchar](200) NULL,
	[CONTENTS] [varchar](400) NULL,
	[FONT_COLOR] [varchar](20) NULL,
	[ALT_TIME] [datetime] NULL,
	[ALT_YN] [char](1) NULL,
	[START_TIME] [datetime] NULL,
	[END_TIME] [datetime] NULL,
	[PARENT_SEQ] [int] NULL,
	[SCH_GRADE] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_NAME] [dbo].[NEW_NAME] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_NAME] [dbo].[EDT_NAME] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
 CONSTRAINT [PK_PRI_SCHEDULE] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 휴가, 2 : 줄장, 3 : 공지, 4 : 기타 ( 휴가 = 1, 출장 = 2 , 공지 = 3 , 기타 = 4, 일정 = 5, 당직 = 6, 공가 = 7, 임원 = 8, 약속안내 =9, ? 입사 =10, 퇴사 =11 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'SCH_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'SCH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'SUBJECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'CONTENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'글자색' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'FONT_COLOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알림시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'ALT_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알림설정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'ALT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지정시작시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'START_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지정마감시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'END_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부모스케쥴' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'PARENT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'중요도 ( 1 : 보통, 2 : 중요 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'SCH_GRADE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'NEW_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'EDT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'개인일정관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRI_SCHEDULE'
GO
