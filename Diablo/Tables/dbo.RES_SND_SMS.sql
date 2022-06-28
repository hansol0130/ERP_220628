USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_SND_SMS](
	[SND_NO] [int] IDENTITY(1,1) NOT NULL,
	[SND_TYPE] [int] NULL,
	[SND_NUMBER] [varchar](20) NULL,
	[BODY] [varchar](1000) NULL,
	[SND_RESULT] [int] NULL,
	[RCV_NUMBER1] [varchar](4) NULL,
	[RCV_NUMBER2] [varchar](4) NULL,
	[RCV_NUMBER3] [varchar](4) NULL,
	[RCV_NAME] [varchar](40) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[SND_METHOD] [char](1) NULL,
	[SND_DATE] [datetime] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[CUS_NO] [int] NULL,
 CONSTRAINT [PK_RES_SND_SMS] PRIMARY KEY CLUSTERED 
(
	[SND_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_SND_SMS]  WITH CHECK ADD  CONSTRAINT [R_286] FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_MASTER_damo] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_SND_SMS] CHECK CONSTRAINT [R_286]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'SND_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'SND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'회신번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'SND_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'본문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'BODY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 확인불가, 1 : 전송성공, 2 : Time Out(이통사), 3 : 핸드폰 호 처리중, 4 : 음영지역, 5 : 파워 오프 6 : 메시지 저장 개수 초과 7 : 잘못된 전화번호 8 : 일시 서비스 중지 9 : 기타 단말기 문제 10 : 착신거절 11 : 기타 12 : 이통사 SMC오류 13 : IB 자체 형식 오류 14 : SMS 불가 단말기 15 : 핸드폰 호 불가상태 16 : SMC 운영자가 메시지 삭제 17 : 이통사 내무 메시지 QUEUE FULL 18 : Time Out(신안정보통신)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'SND_RESULT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송전화번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'RCV_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송전화번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'RCV_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송전화번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'RCV_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'RCV_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 즉시전송 1 : 예약전송 (  즉시전송 = 0, 예약전송 = 1 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'SND_METHOD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전송일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'SND_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 SMS발송내역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_SMS'
GO
