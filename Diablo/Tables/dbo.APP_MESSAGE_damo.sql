USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_MESSAGE_damo](
	[MSG_SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NOT NULL,
	[MSG_TYPE] [int] NULL,
	[OS_TYPE] [int] NULL,
	[REMARK] [varchar](2000) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[PRO_CODE] [varchar](100) NULL,
	[RES_CODE] [varchar](200) NULL,
	[Tag] [varchar](20) NULL,
	[TITLE] [varchar](200) NULL,
	[sec_GPS_X] [varbinary](16) NULL,
	[sec_GPS_Y] [varbinary](16) NULL,
	[MSG_PATH] [varchar](200) NULL,
 CONSTRAINT [PK_APP_MESSAGE] PRIMARY KEY CLUSTERED 
(
	[MSG_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_MESSAGE_damo]  WITH CHECK ADD  CONSTRAINT [R_547] FOREIGN KEY([CUS_NO])
REFERENCES [dbo].[CUS_CUSTOMER_damo] ([CUS_NO])
GO
ALTER TABLE [dbo].[APP_MESSAGE_damo] CHECK CONSTRAINT [R_547]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'알림고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'MSG_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'100 : 일반알림(전달사항), 200 : 마케팅알림,  300 : 예약관련 알림, 400 : 인솔자 알림' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'MSG_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : Android, 2 : iOS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'OS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'태그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'Tag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GPS X' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'sec_GPS_X'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GPS Y' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'sec_GPS_Y'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메세지파일위치' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo', @level2type=N'COLUMN',@level2name=N'MSG_PATH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객 알림 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_MESSAGE_damo'
GO
