USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TMP_AS_CALL_2015](
	[seq] [float] NULL,
	[행사코드] [nvarchar](255) NULL,
	[예약코드] [nvarchar](255) NULL,
	[행사명] [nvarchar](255) NULL,
	[출발일] [datetime] NULL,
	[도착일] [datetime] NULL,
	[상품타입] [nvarchar](255) NULL,
	[협력사] [nvarchar](255) NULL,
	[예약구분] [nvarchar](255) NULL,
	[고객명] [nvarchar](255) NULL,
	[연락처] [nvarchar](255) NULL,
	[이메일] [nvarchar](255) NULL,
	[수익팀] [nvarchar](255) NULL,
	[담당자] [nvarchar](255) NULL,
	[인솔자] [nvarchar](255) NULL,
	[회원번호] [float] NULL,
	[여행횟수] [float] NULL,
	[예약자] [nvarchar](255) NULL,
	[판매정보] [nvarchar](255) NULL,
	[통화일자] [datetime] NULL,
	[진행사항_(성공/_실패)] [nvarchar](255) NULL,
	[결과_(성공/_거부/_실패)] [nvarchar](255) NULL,
	[직원친철도(인솔자)_1~10점] [float] NULL,
	[직원친철도(가이드)_1~10점] [float] NULL,
	[여행만족도  (여행전반)_1~10점] [float] NULL,
	[만족_항목] [nvarchar](255) NULL,
	[불만족_항목] [nvarchar](255) NULL,
	[여행계획] [nvarchar](max) NULL,
	[이메일수신동의] [nvarchar](255) NULL,
	[처리사항,_코드화] [nvarchar](255) NULL,
	[고객의 소리] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
