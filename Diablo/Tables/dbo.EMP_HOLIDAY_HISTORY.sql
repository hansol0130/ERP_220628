USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMP_HOLIDAY_HISTORY](
	[EDI_CODE] [dbo].[EDI_CODE] NOT NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[APPLY_YEAR] [char](4) NULL,
	[HOLIDAY_TYPE] [char](1) NULL,
	[SAL_TYPE] [char](1) NULL,
	[APPLY_YN] [char](1) NULL,
	[HOLIDAY_CODE] [dbo].[PUB_CODE] NULL,
	[JOIN_DATE] [smalldatetime] NULL,
	[OUT_DATE] [smalldatetime] NULL,
	[USE_DAY] [numeric](18, 1) NULL,
	[REMARK] [varchar](200) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[HOLIDAY_USE_DAY] [numeric](18, 1) NULL,
 CONSTRAINT [PK_EMP_HOLIDAY_HISTORY] PRIMARY KEY CLUSTERED 
(
	[EDI_CODE] ASC,
	[EMP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용년도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'APPLY_YEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'( 연차 = 1, 공가, 보건휴가, 대체휴가, 휴직  ) -> ( 휴가 = 1, 출장 = 2 )  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'HOLIDAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 유급, 2 : 무급' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'SAL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y : 연차에서 날짜 제외,  N : 연차에서 날짜 제외하지않음' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'APPLY_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'휴가&출장 세부코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'HOLIDAY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'JOIN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'OUT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'USE_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'관리자비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'연차사용일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY', @level2type=N'COLUMN',@level2name=N'HOLIDAY_USE_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장휴가내역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY_HISTORY'
GO
