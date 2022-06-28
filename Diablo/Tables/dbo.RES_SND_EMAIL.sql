USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RES_SND_EMAIL](
	[SND_NO] [int] IDENTITY(1,1) NOT NULL,
	[SND_NAME] [varchar](20) NULL,
	[SND_EMAIL] [varchar](50) NULL,
	[RCV_NAME] [varchar](40) NULL,
	[RCV_EMAIL] [varchar](100) NULL,
	[CFM_YN] [dbo].[USE_N] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[TITLE] [varchar](200) NULL,
	[BODY] [nvarchar](max) NULL,
	[CFM_DATE] [datetime] NULL,
	[SND_TYPE] [int] NULL,
	[REF_EMAIL] [varchar](100) NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
	[CFM_HEADER] [varchar](300) NULL,
	[CFM_IP] [varchar](20) NULL,
	[DOC_NO] [int] NULL,
 CONSTRAINT [PK_RES_SND_EMAIL] PRIMARY KEY CLUSTERED 
(
	[SND_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[RES_SND_EMAIL] ADD  CONSTRAINT [DF_RES_SND_EMAIL_DOC_NO]  DEFAULT ((0)) FOR [DOC_NO]
GO
ALTER TABLE [dbo].[RES_SND_EMAIL]  WITH CHECK ADD  CONSTRAINT [R_285] FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_MASTER_damo] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RES_SND_EMAIL] CHECK CONSTRAINT [R_285]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'SND_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'SND_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신자EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'SND_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'RCV_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발송자EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'RCV_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'CFM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'제목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'본문' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'BODY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'CFM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'( None = 0, 일정표 = 1, 확정일정표=2, 결제메일=3, 입금안내=4, 전달사항=5, 여행자계약서=6, 예약확정=7, 예약완료=8, 예약취소=9, 회원가입=10, 항공예약완료 =11, 항공예약취소=12, 호텔예약완료=13, 호텔예약취소=14, 패스워드전송=15, 포인트적립=16, 포인트사용=17, 포인트소멸=18, 항공예약확정=19, 항공출발완료=20, 여행일정표=21,호텔결제완료=22, 호텔결제취소=23, 호텔바우처=24, 호텔상세정보=25, 호텔인보이스=26, 상품추천=27, 현금영수증=28, 롯데면세점쿠폰=29, 카드결제메일=30, 포인트결제메일=31, 수배요청=32, 인보이스확정=33, 룰렛이벤트=34,CTI_ARS=35, CTI_상담앱=36, 휴면계정=37, BTMS비밀번호초기화 = 100, BTMS호텔예약확정=101, BTMS호텔예약접수=102, BTMS호텔예약취소=103, BTMS호텔바우처=104, BTMS항공예약확정=105, BTMS항공예약취소=106,BTMS기타예약확정=107, BTMS기타예약취소=108, BTMS규정위반호텔=109, BTMS규정위반항공=110, BTMS온라인상담답변완료=111, BTMS출장반려=112, APP정보안내=113, 신세계면세점쿠폰=114, 제2여객터미널_안내=115, 새벽출발_안내=116, 알림톡=117, SMS=118 )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'SND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'참조자EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'REF_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신 헤더값' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'CFM_HEADER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신IP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'CFM_IP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL', @level2type=N'COLUMN',@level2name=N'DOC_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약 이메일발송내역' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RES_SND_EMAIL'
GO
