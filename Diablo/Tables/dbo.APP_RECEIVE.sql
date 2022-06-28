USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_RECEIVE](
	[MSG_SEQ_NO] [int] NOT NULL,
	[SEQ_NO] [int] NOT NULL,
	[RES_CODE] [char](12) NULL,
	[RES_SEQ_NO] [int] NULL,
	[CUS_NO] [int] NULL,
	[OS_TYPE] [int] NULL,
	[RCV_DATE] [datetime] NULL,
	[RCV_TYPE] [int] NULL,
	[RCV_MSG] [varchar](1000) NULL,
	[CUS_DEVICE_ID] [varchar](1000) NULL,
	[READ_DATE] [datetime] NULL,
 CONSTRAINT [PK_APP_RECEIVE] PRIMARY KEY CLUSTERED 
(
	[MSG_SEQ_NO] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_RECEIVE]  WITH CHECK ADD  CONSTRAINT [R_549] FOREIGN KEY([MSG_SEQ_NO])
REFERENCES [dbo].[APP_MESSAGE_damo] ([MSG_SEQ_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[APP_RECEIVE] CHECK CONSTRAINT [R_549]
GO
ALTER TABLE [dbo].[APP_RECEIVE]  WITH CHECK ADD  CONSTRAINT [R_550] FOREIGN KEY([CUS_NO])
REFERENCES [dbo].[CUS_CUSTOMER_damo] ([CUS_NO])
GO
ALTER TABLE [dbo].[APP_RECEIVE] CHECK CONSTRAINT [R_550]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알림고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'MSG_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'RES_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : Android, 2 : iOS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'OS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'RCV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 발송, 1 : 수신, 2 : 에러' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'RCV_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신메세지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'RCV_MSG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객장비아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'CUS_DEVICE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신일(모바일,앱)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE', @level2type=N'COLUMN',@level2name=N'READ_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객 알림 수신' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_RECEIVE'
GO
