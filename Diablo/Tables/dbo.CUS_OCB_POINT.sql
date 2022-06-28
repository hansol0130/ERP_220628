USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_OCB_POINT](
	[SEQ_NO] [int] IDENTITY(1,1) NOT NULL,
	[POINT_TYPE] [int] NULL,
	[FUNC_NAME] [varchar](50) NULL,
	[CUS_NO] [int] NULL,
	[TRC_NO] [char](10) NULL,
	[SEND_DY] [char](8) NULL,
	[SEND_TM] [char](6) NULL,
	[CARD_NUM] [char](19) NULL,
	[CI] [char](88) NULL,
	[DEAL_AMT] [int] NULL,
	[SUCC_FAIL] [char](1) NULL,
	[APRV_DY] [char](8) NULL,
	[APRV_TM] [char](6) NULL,
	[APRV_NO] [char](9) NULL,
	[MSG] [varchar](256) NULL,
	[REQ_POINT] [int] NULL,
	[RET_POINT] [int] NULL,
	[REQ_STRING] [varchar](1000) NULL,
	[RET_STRING] [varchar](1000) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[CXL_YN] [char](1) NULL,
	[CXL_DATE] [datetime] NULL,
	[CXL_POINT] [int] NULL,
	[RES_CODE] [dbo].[RES_CODE] NULL,
 CONSTRAINT [PK_CUS_OCB_POINT] PRIMARY KEY CLUSTERED 
(
	[SEQ_NO] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO