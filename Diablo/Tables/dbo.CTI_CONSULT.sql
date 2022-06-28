USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CTI_CONSULT](
	[CTI_NO] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NULL,
	[NOR_TEL1] [varchar](6) NULL,
	[NOR_TEL2] [varchar](5) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[CTI_STATE] [char](3) NULL,
	[CTI_TYPE] [int] NULL,
	[CONTENTS] [varchar](max) NULL,
	[RCV_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[TEAM_CODE] [dbo].[TEAM_CODE] NULL,
	[NEW_DATE] [datetime] NULL,
	[CALL_YN] [char](1) NULL,
	[CUS_DATE] [datetime] NULL,
	[SEQ_NO] [int] NULL,
 CONSTRAINT [PK_CTI_CONSULT] PRIMARY KEY CLUSTERED 
(
	[CTI_NO] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품 : 0, 예약 : 1, 결제 : 2, 여권 : 3, 포인트 : 4, 홈페이지 : 5, 불만 : 6, 기타 : 7, 부재 : 8, 내용없음 : 9, 전체 : 99' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'CTI_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팀코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'최초등록일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTI_CONSULT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상담이력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTI_CONSULT'
GO
