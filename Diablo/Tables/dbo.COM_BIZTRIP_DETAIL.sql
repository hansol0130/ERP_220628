USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COM_BIZTRIP_DETAIL](
	[AGT_CODE] [varchar](10) NOT NULL,
	[BT_CODE] [varchar](20) NOT NULL,
	[BT_RES_SEQ] [int] NOT NULL,
	[RES_CODE] [varchar](20) NULL,
	[PRO_DETAIL_TYPE] [int] NULL,
	[PAY_LATER_EMP_SEQ] [int] NULL,
	[PAY_LATER_DATE] [datetime] NULL,
	[PAY_LATER_EMP_CODE] [char](7) NULL,
 CONSTRAINT [PK_COM_BIZTRIP_DETAIL] PRIMARY KEY CLUSTERED 
(
	[AGT_CODE] ASC,
	[BT_CODE] ASC,
	[BT_RES_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL', @level2type=N'COLUMN',@level2name=N'BT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL', @level2type=N'COLUMN',@level2name=N'BT_RES_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공 : 2, 호텔 : 3, 렌트카 : 4, 비자 : 5, 기타 : 9, 전체 : 10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL', @level2type=N'COLUMN',@level2name=N'PRO_DETAIL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'후불처리고객사직원번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL', @level2type=N'COLUMN',@level2name=N'PAY_LATER_EMP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'후불지정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL', @level2type=N'COLUMN',@level2name=N'PAY_LATER_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'추불처리자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL', @level2type=N'COLUMN',@level2name=N'PAY_LATER_EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장예약디테일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COM_BIZTRIP_DETAIL'
GO
