USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_DOWNLOAD_LOG](
	[LOG_SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[APP_CODE] [int] NOT NULL,
	[RES_CODE] [char](12) NULL,
	[CUS_NO] [int] NULL,
	[DOWNLOAD_DATE] [varchar](8) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_APP_DOWNLOAD] PRIMARY KEY CLUSTERED 
(
	[LOG_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_DOWNLOAD_LOG]  WITH CHECK ADD  CONSTRAINT [R_APP_MASTER_TO_APP_DOWNLOAD_LOG] FOREIGN KEY([APP_CODE])
REFERENCES [dbo].[APP_MASTER] ([APP_CODE])
GO
ALTER TABLE [dbo].[APP_DOWNLOAD_LOG] CHECK CONSTRAINT [R_APP_MASTER_TO_APP_DOWNLOAD_LOG]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'로그일련번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_DOWNLOAD_LOG', @level2type=N'COLUMN',@level2name=N'LOG_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'앱코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_DOWNLOAD_LOG', @level2type=N'COLUMN',@level2name=N'APP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_DOWNLOAD_LOG', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_DOWNLOAD_LOG', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'다운로드일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_DOWNLOAD_LOG', @level2type=N'COLUMN',@level2name=N'DOWNLOAD_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_DOWNLOAD_LOG', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'앱다운로드로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_DOWNLOAD_LOG'
GO
