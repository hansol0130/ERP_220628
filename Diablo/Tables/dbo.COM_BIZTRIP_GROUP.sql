USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BIZTRIP_GROUP](
	[AGT_CODE] [varchar](10) NOT NULL,
	[BT_SEQ] [int] NOT NULL,
	[BTG_NAME] [varchar](20) NULL,
	[ALL_YN] [char](1) NULL,
	[REPORT_YN] [char](1) NULL,
	[EMAIL_SEND_YN] [char](1) NULL,
	[CONFIRM_YN] [char](1) NULL,
	[AIR_SAME_YN] [char](1) NULL,
	[AIR_LIKE_YN] [char](1) NULL,
	[HOTEL_LIKE_YN] [char](1) NULL,
	[ORDER_NUM] [int] NULL,
	[USE_YN] [char](1) NULL,
	[NEW_DATE] [datetime] NULL,
	[NEW_SEQ] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_SEQ] [int] NULL,
 CONSTRAINT [PK_COM_BIZTRIP_GROUP_MASTER] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[BT_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장그룹순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'BT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장그룹명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'BTG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전체유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'ALL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'규정위반사유작성유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'REPORT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'규정위반이메일보고유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'EMAIL_SEND_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장승인필요유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'CONFIRM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'동일항공사이용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'AIR_SAME_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선호항공사이용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'AIR_LIKE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'선호호텔이용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'HOTEL_LIKE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우선순위' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'ORDER_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'NEW_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP', @level2type=N'COLUMN',@level2name=N'EDT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객사출장그룹관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_GROUP'
GO
