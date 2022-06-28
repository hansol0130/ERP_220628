USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_PUSH_MSG_INFO](
	[MSG_NO] [int] IDENTITY(1,1) NOT NULL,
	[TEMPLATE_TYPE] [varchar](1) NOT NULL,
	[TITLE] [varchar](50) NOT NULL,
	[MSG] [varchar](1000) NULL,
	[MSG_DETAIL] [varchar](1000) NULL,
	[RECV_DATE] [datetime] NOT NULL,
	[IMAGE_URL] [varchar](200) NULL,
	[LINK_URL] [varchar](200) NULL,
 CONSTRAINT [PK_APP_PUSH_MESSAGE] PRIMARY KEY CLUSTERED 
(
	[MSG_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메세지번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO', @level2type=N'COLUMN',@level2name=N'MSG_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'푸시템플릿타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO', @level2type=N'COLUMN',@level2name=N'TEMPLATE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'푸시메세지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO', @level2type=N'COLUMN',@level2name=N'MSG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO', @level2type=N'COLUMN',@level2name=N'MSG_DETAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO', @level2type=N'COLUMN',@level2name=N'RECV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이미지주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO', @level2type=N'COLUMN',@level2name=N'IMAGE_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'푸시링크주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO', @level2type=N'COLUMN',@level2name=N'LINK_URL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP발송_푸시메세지정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_INFO'
GO
