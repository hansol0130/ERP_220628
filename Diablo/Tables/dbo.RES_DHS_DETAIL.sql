USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_DHS_DETAIL](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[DHS_RES_CODE] [varchar](20) NULL,
	[RES_NAME] [varchar](40) NULL,
	[RES_PHONE] [varchar](20) NULL,
	[DHS_ROOM_CODE] [varchar](20) NULL,
	[RES_TALK_SEND] [datetime] NULL,
	[CFM_TALK_SEND] [datetime] NULL,
	[CFM_CODE] [varchar](20) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_DATE] [datetime] NULL,
 CONSTRAINT [PK_RES_DHS_DETAIL] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_DHS_DETAIL]  WITH CHECK ADD FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_MASTER_damo] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'홈쇼핑예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'DHS_RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'홈쇼핑에서 전달받은 예약자 명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약자 연락처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객이 예약한 룸타입 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'DHS_ROOM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약알림톡 발송일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_TALK_SEND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'확정알림톡 발송일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'CFM_TALK_SEND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔예약확정코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'CFM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일/숙박일확정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_DHS_DETAIL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
