USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_COUPON_DOWNLOAD](
	[COUPON_ID] [varchar](50) NOT NULL,
	[USER_ID] [varchar](50) NOT NULL,
	[USER_NAME] [nchar](10) NULL,
	[DOWNLOAD_DATE] [datetime] NULL,
	[RESV_NO] [int] NULL,
	[DISCNT_AMT] [decimal](18, 0) NULL,
	[RESV_USE_YN] [varchar](1) NULL,
	[ISSUE_TYPE] [varchar](1) NULL,
	[ISSUE_ID] [varchar](50) NULL,
	[APPLY_AMT] [decimal](18, 0) NULL,
	[PRE_RESV_NO] [int] NULL,
	[PRE_DISCNT_AMT] [decimal](18, 0) NULL,
	[PRE_APPLY_AMT] [decimal](18, 0) NULL,
	[CANCEL_DATE] [datetime] NULL,
 CONSTRAINT [PK_HTL_COUPON_DOWNLOAD] PRIMARY KEY CLUSTERED 
(
	[COUPON_ID] ASC,
	[USER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO