USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_DHS_DETAIL_LOG](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[CFM_CODE] [varchar](20) NULL,
	[CLIENT_IP] [varchar](20) NOT NULL,
	[NEW_DATE] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_DHS_DETAIL_LOG] ADD  CONSTRAINT [DF_RES_DHS_DETAIL_LOG_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL_LOG', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔예약확정코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL_LOG', @level2type=N'COLUMN',@level2name=N'CFM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'클라이언트 IP주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL_LOG', @level2type=N'COLUMN',@level2name=N'CLIENT_IP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL_LOG', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
