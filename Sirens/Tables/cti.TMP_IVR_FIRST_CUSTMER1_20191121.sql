USE [Sirens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cti].[TMP_IVR_FIRST_CUSTMER1_20191121](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[TEL1] [varchar](10) NULL,
	[TEL2] [varchar](10) NULL,
	[TEL3] [varchar](10) NULL,
	[INNER_NUM] [varchar](20) NULL,
	[STARTTIME] [datetime] NULL,
	[ENDTIME] [datetime] NULL,
 CONSTRAINT [PKTMP_IVR_FIRST_CUSTMER1_20191121] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
