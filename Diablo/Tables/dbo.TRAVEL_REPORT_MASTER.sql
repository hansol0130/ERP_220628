USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRAVEL_REPORT_MASTER](
	[OTR_SEQ] [int] IDENTITY(1,1) NOT NULL,
	[OTR_STATE] [int] NULL,
	[PRO_CODE] [varchar](20) NOT NULL,
	[EDI_CODE] [dbo].[EDI_CODE] NULL,
	[NEW_CODE] [varchar](10) NOT NULL,
	[AGT_CODE] [varchar](10) NULL,
	[PAY_ASSIGN] [int] NULL,
	[REMARK] [varchar](max) NULL,
	[SEAT_COUNT] [int] NULL,
	[SEAT_BELT_YN] [char](1) NULL,
	[SEAT_REMARK] [varchar](max) NULL,
	[SUG_REMARK] [varchar](max) NULL,
	[NEW_DATE] [datetime] NULL,
 CONSTRAINT [PK_TRAVEL_REPORT_MASTER] PRIMARY KEY CLUSTERED 
(
	[OTR_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 미작성, 1 : 작성중, 2 : 결재중, 3 : 작성완료, 4 : 재검토' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TRAVEL_REPORT_MASTER', @level2type=N'COLUMN',@level2name=N'OTR_STATE'
GO
