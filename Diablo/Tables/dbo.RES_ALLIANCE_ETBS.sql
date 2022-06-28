USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_ALLIANCE_ETBS](
	[ETBS_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[RES_CODE] [varchar](15) NULL,
	[ETBS_CODE] [varchar](30) NULL,
	[RES_STATE] [int] NULL,
	[NEW_DATE] [datetime] NULL,
	[VENDOR] [varchar](20) NULL,
	[SVID] [varchar](10) NULL,
	[ETB_USERID] [varchar](30) NULL,
	[ETB_CUSURL] [varchar](100) NULL,
 CONSTRAINT [PK_TMP_ALLIANCE_ETBS] PRIMARY KEY CLUSTERED 
(
	[ETBS_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALLIANCE_ETBS', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ETBS예약번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALLIANCE_ETBS', @level2type=N'COLUMN',@level2name=N'ETBS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ETBS결제타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALLIANCE_ETBS', @level2type=N'COLUMN',@level2name=N'VENDOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴사svid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALLIANCE_ETBS', @level2type=N'COLUMN',@level2name=N'SVID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴사사용자ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALLIANCE_ETBS', @level2type=N'COLUMN',@level2name=N'ETB_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴사접속정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALLIANCE_ETBS', @level2type=N'COLUMN',@level2name=N'ETB_CUSURL'
GO
