USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BIZTRIP_MASTER](
	[AGT_CODE] [varchar](10) NOT NULL,
	[BT_CODE] [varchar](20) NOT NULL,
	[PRO_CODE] [varchar](20) NULL,
	[BT_NAME] [varchar](200) NULL,
	[BT_CITY_CODE] [varchar](3) NULL,
	[BT_START_DATE] [datetime] NULL,
	[BT_END_DATE] [datetime] NULL,
	[BT_TIME_LIMIT] [datetime] NULL,
	[BT_REASON] [varchar](100) NULL,
	[APPROVAL_STATE] [int] NULL,
	[REQUEST_DATE] [datetime] NULL,
	[REQUEST_REMARK] [varchar](500) NULL,
	[CONFIRM_DATE] [datetime] NULL,
	[CONFIRM_EMP_SEQ] [int] NULL,
	[CONFIRM_REMARK] [varchar](500) NULL,
	[PAY_REQUEST_DATE] [datetime] NULL,
	[LAST_NEW_DATE] [datetime] NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_SEQ] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [char](7) NULL,
 CONSTRAINT [PK_COM_BIZTRIP_MASTER] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[BT_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'BT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'BT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공, 호텔 예약, 취소 시 업데이트 기타예약인 경우 업데이트 되지 않는다.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'BT_CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'BT_START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'BT_END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초결제마감일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'BT_TIME_LIMIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장목적' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'BT_REASON'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인상태(0 : 출장접수, 1 : 승인진행, 2 : 출장확정, 9 : 출장반려, 10 : 전체)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'APPROVAL_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인요청일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'REQUEST_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인요청비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'REQUEST_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'CONFIRM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'CONFIRM_EMP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'승인비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'CONFIRM_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'대금청구일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'PAY_REQUEST_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최종등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'LAST_NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정직원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장예약마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_MASTER'
GO
