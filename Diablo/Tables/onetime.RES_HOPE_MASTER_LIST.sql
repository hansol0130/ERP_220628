USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [onetime].[RES_HOPE_MASTER_LIST](
	[순번] [int] NULL,
	[출하지시일] [nvarchar](255) NULL,
	[차수] [nvarchar](255) NULL,
	[주문번호] [nvarchar](255) NULL,
	[주문구분] [nvarchar](255) NULL,
	[우선배송여부] [nvarchar](255) NULL,
	[주문자] [nvarchar](255) NULL,
	[주문자(연락처)] [nvarchar](255) NULL,
	[주문자(핸드폰)] [nvarchar](255) NULL,
	[생년월일] [nvarchar](255) NULL,
	[성별] [nvarchar](255) NULL,
	[인수자] [nvarchar](255) NULL,
	[인수자(연락처)] [nvarchar](255) NULL,
	[인수자(핸드폰)] [nvarchar](255) NULL,
	[고객OB정보] [nvarchar](255) NULL,
	[전언] [nvarchar](255) NULL,
	[상품구분] [nvarchar](255) NULL,
	[협력사상품코드] [nvarchar](255) NULL,
	[상품코드] [nvarchar](255) NULL,
	[단품] [nvarchar](255) NULL,
	[협력사상품코드1] [nvarchar](255) NULL,
	[링크샵코드생성처] [nvarchar](255) NULL,
	[링크샵상품코드] [nvarchar](255) NULL,
	[상품명] [nvarchar](255) NULL,
	[OneTV_상품여부] [nvarchar](255) NULL,
	[단품상세] [nvarchar](255) NULL,
	[주문수량] [float] NULL,
	[주문고객주민번호] [nvarchar](255) NULL,
	[주문고객영문명] [nvarchar](255) NULL,
	[주문일시] [nvarchar](255) NULL,
	[주문고객전화] [nvarchar](255) NULL,
	[주문고객핸드폰] [nvarchar](255) NULL,
	[주문고객이메일] [nvarchar](255) NULL,
	[공급가(현재)] [float] NULL,
	[공급가(주문시점)] [float] NULL,
	[주문금액] [float] NULL,
	[실주문금액] [float] NULL,
	[약정구분] [nvarchar](255) NULL,
	[취소여부] [nvarchar](255) NULL,
	[지정구분] [nvarchar](255) NULL,
	[배송예정일] [nvarchar](255) NULL,
	[스마트픽여부] [nvarchar](255) NULL,
	[주소구분] [nvarchar](255) NULL,
	[우편번호] [nvarchar](255) NULL,
	[배송지] [nvarchar](255) NULL,
	[축언] [nvarchar](255) NULL,
	[예외상품여부] [nvarchar](255) NULL,
	[직송연동여부] [nvarchar](255) NULL,
	[고객주문시간] [nvarchar](255) NULL,
	[NoName] [nvarchar](255) NULL,
	[SEND_YN] [char](1) NULL,
	[SEND_SN] [varchar](20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [onetime].[RES_HOPE_MASTER_LIST] ADD  DEFAULT ('N') FOR [SEND_YN]
GO
