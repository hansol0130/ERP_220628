USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APP_PUSH_SEND_HISTORY](
	[SEND_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[MSG_NO] [int] NOT NULL,
	[RES_TIME] [datetime] NULL,
	[RECV_AGE] [varchar](50) NOT NULL,
	[RECV_GENDER] [varchar](1) NOT NULL,
	[RECV_OS_TYPE] [varchar](10) NOT NULL,
	[RECV_CODE_TYPE] [varchar](3) NOT NULL,
	[RECV_CODE] [varchar](100) NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[NEW_CODE] [varchar](7) NOT NULL,
	[CANCEL_YN] [varchar](1) NOT NULL,
	[ERP_CNT] [int] NOT NULL,
	[SEND_CNT] [int] NOT NULL,
	[RECV_CNT] [int] NOT NULL,
	[RES_HISTORY] [varchar](10) NULL,
	[SEND_TYPE] [varchar](1) NULL,
	[RECV_MEM_CNT] [int] NOT NULL,
	[RECV_ETC_CNT] [int] NOT NULL,
	[RECV_AND_CNT] [int] NOT NULL,
	[RECV_IOS_CNT] [int] NOT NULL,
	[RECV_BLK_CNT] [int] NOT NULL,
	[RECV_FAL_CNT] [int] NOT NULL,
	[RECV_MEMBER] [varchar](1) NULL,
 CONSTRAINT [PK_APP_PUSH_SEND_HISTORY] PRIMARY KEY CLUSTERED 
(
	[SEND_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  CONSTRAINT [DF_APP_PUSH_SEND_CANCEL_YN]  DEFAULT ('N') FOR [CANCEL_YN]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  CONSTRAINT [DF_APP_PUSH_SEND_ERP_COUNT]  DEFAULT ((0)) FOR [ERP_CNT]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  CONSTRAINT [DF_APP_PUSH_SEND_SEND_COUNT]  DEFAULT ((0)) FOR [SEND_CNT]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  DEFAULT ((0)) FOR [RECV_MEM_CNT]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  DEFAULT ((0)) FOR [RECV_ETC_CNT]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  DEFAULT ((0)) FOR [RECV_AND_CNT]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  DEFAULT ((0)) FOR [RECV_IOS_CNT]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  DEFAULT ((0)) FOR [RECV_BLK_CNT]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] ADD  DEFAULT ((0)) FOR [RECV_FAL_CNT]
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY]  WITH CHECK ADD  CONSTRAINT [FK_APP_PUSH_SEND_HISTORY_APP_PUSH_SEND_HISTORY] FOREIGN KEY([MSG_NO])
REFERENCES [dbo].[APP_PUSH_MSG_INFO] ([MSG_NO])
GO
ALTER TABLE [dbo].[APP_PUSH_SEND_HISTORY] CHECK CONSTRAINT [FK_APP_PUSH_SEND_HISTORY_APP_PUSH_SEND_HISTORY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'송신번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'SEND_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'메세지번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'MSG_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신연령' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_AGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신성별' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신OS타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_OS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_CODE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'CANCEL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP상수신고객수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'ERP_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제송신고객수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'SEND_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제수신고객수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약이력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RES_HISTORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'송신타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'SEND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회원_수신수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_MEM_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타_수신수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_ETC_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Android 수신수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_AND_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IOS 수신수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_IOS_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'차단수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_BLK_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실패수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_FAL_CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'다중상품표시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY', @level2type=N'COLUMN',@level2name=N'RECV_MEMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP발송_푸시송신이력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'APP_PUSH_SEND_HISTORY'
GO
