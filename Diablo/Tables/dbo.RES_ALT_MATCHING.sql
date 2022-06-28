USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_ALT_MATCHING](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[ALT_NAME] [varchar](20) NULL,
	[ALT_CODE] [varchar](20) NOT NULL,
	[ALT_RES_CODE] [varchar](50) NULL,
	[NEW_CODE] [int] NOT NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[ALT_PRO_URL] [varchar](1000) NULL,
	[ALT_MEM_NO] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴 업체 명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING', @level2type=N'COLUMN',@level2name=N'ALT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴 업체 코드(업체명 약자 사용)  Jeju - 제주닷컴, Hanjin - 한진렌터카, Theme - 테마캠프' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING', @level2type=N'COLUMN',@level2name=N'ALT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴 업체 예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING', @level2type=N'COLUMN',@level2name=N'ALT_RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최종 수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최종 수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴상품URL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING', @level2type=N'COLUMN',@level2name=N'ALT_PRO_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING', @level2type=N'COLUMN',@level2name=N'ALT_MEM_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제휴업체 예약 매칭' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_ALT_MATCHING'
GO
