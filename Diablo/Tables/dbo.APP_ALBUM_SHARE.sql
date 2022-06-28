USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_ALBUM_SHARE](
	[ALBUM_SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NOT NULL,
	[PRO_CODE] [varchar](20) NULL,
	[RES_CODE] [char](12) NULL,
	[FILENAME] [varchar](200) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [XPKAPP_ALBUM_SHARE] PRIMARY KEY CLUSTERED 
(
	[ALBUM_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_ALBUM_SHARE]  WITH CHECK ADD  CONSTRAINT [R_558] FOREIGN KEY([CUS_NO])
REFERENCES [dbo].[CUS_CUSTOMER_damo] ([CUS_NO])
GO
ALTER TABLE [dbo].[APP_ALBUM_SHARE] CHECK CONSTRAINT [R_558]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'앨범고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_ALBUM_SHARE', @level2type=N'COLUMN',@level2name=N'ALBUM_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_ALBUM_SHARE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_ALBUM_SHARE', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_ALBUM_SHARE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_ALBUM_SHARE', @level2type=N'COLUMN',@level2name=N'FILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_ALBUM_SHARE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_ALBUM_SHARE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행앨범공유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_ALBUM_SHARE'
GO
