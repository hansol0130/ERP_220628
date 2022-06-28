USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_PUSH_MSG_ALARM](
	[MSG_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[MSG_NO] [int] NOT NULL,
	[CUS_NO] [int] NOT NULL,
	[READ_DATE] [datetime] NULL,
	[TRAN_STATE] [varchar](1) NULL,
	[TRAN_RESULT] [varchar](500) NULL,
 CONSTRAINT [PK_APP_PUSH_MSG] PRIMARY KEY CLUSTERED 
(
	[MSG_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_PUSH_MSG_ALARM]  WITH CHECK ADD  CONSTRAINT [FK_APP_PUSH_MSG_APP_PUSH_MSG_GROUP] FOREIGN KEY([MSG_NO])
REFERENCES [dbo].[APP_PUSH_MSG_INFO] ([MSG_NO])
GO
ALTER TABLE [dbo].[APP_PUSH_MSG_ALARM] CHECK CONSTRAINT [FK_APP_PUSH_MSG_APP_PUSH_MSG_GROUP]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메세지순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_ALARM', @level2type=N'COLUMN',@level2name=N'MSG_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메세지번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_ALARM', @level2type=N'COLUMN',@level2name=N'MSG_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_ALARM', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'푸시수신일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_ALARM', @level2type=N'COLUMN',@level2name=N'READ_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'푸시성공여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_ALARM', @level2type=N'COLUMN',@level2name=N'TRAN_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'푸시결과값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_ALARM', @level2type=N'COLUMN',@level2name=N'TRAN_RESULT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP발송_푸시전송결과' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_MSG_ALARM'
GO
