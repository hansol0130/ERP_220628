USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_RESV_RECEIPT](
	[REC_NO] [int] NOT NULL,
	[RESV_NO] [int] NULL,
	[TRAN_NO] [varchar](100) NULL,
	[REG_NO] [varchar](50) NULL,
	[APP_NO] [varchar](50) NULL,
	[APP_DATE] [datetime] NULL,
	[CSHR_AMT] [decimal](18, 0) NULL,
	[CSHR_SUPP_AMT] [decimal](18, 0) NULL,
	[CSHR_TAX] [decimal](18, 0) NULL,
	[CSHR_SVC_AMT] [decimal](18, 0) NULL,
	[CSHR_TYPE] [varchar](1) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATE_USER] [varchar](50) NULL,
	[CANCEL_YN] [varchar](1) NULL,
	[APP_CXL_NO] [varchar](50) NULL,
	[CANCEL_DATE] [datetime] NULL,
	[CANCEL_USER] [varchar](50) NULL,
 CONSTRAINT [PK_HTL_RESV_RECEIPT] PRIMARY KEY CLUSTERED 
(
	[REC_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO